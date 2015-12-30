package main


import (
	"fmt"
	"os"
	"crypto/md5"
	"sort"
	"sync"
	"io/ioutil"
	"path/filepath"
	"errors"
)


type result struct {
	path string
	sum  [md5.Size]byte
	err  error
}


func walkFiles(done <-chan struct{}, root string) (<-chan string, <-chan error) {
	paths := make(chan string)
	errc := make(chan error, 1)

	go func() {
		// After Walk returns we have to signal that there are no more files
		// waiting for digestion
		defer close(paths)

		errc <- filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.Mode().IsRegular() {
				return nil
			}

			select {
			case paths <- path:
			case <-done:
				return errors.New("walk canceled")
			}

			return nil
		})
	}()

	return paths, errc
}

func digester(done <-chan struct{}, paths <-chan string, c chan<- result) {
	for p := range paths {
		data, err := ioutil.ReadFile(p)
		select {
		case c <- result{p, md5.Sum(data), err}:
		case <-done:
			return
		}
	}
}

func MD5All(root string) (map[string][md5.Size]byte, error) {
	// `done` communicates that there was either an error during parsing
	// or MD5All has walked all the files in the directory
	done := make(chan struct{})
	defer close(done)

	// Start generating files for serialization
	paths, errc := walkFiles(done, root)

	c := make(chan result)

	var wg sync.WaitGroup
	const numDigesters = 20
	wg.Add(numDigesters)

	// Digest a fixed number of files each time
	for i := 0; i < numDigesters; i++ {
		go func() {
			digester(done, paths, c)
			wg.Done()
		}()
	}

	// Wait for all results and close the `result` channel
	go func() {
		wg.Wait()
		close(c)
	}()

	// Prepare results
	m := make(map[string][md5.Size]byte)
	for r := range c {
		if r.err != nil {
			// close(done) will signal `sumFiles` that something bad has happened
			return nil, r.err
		}
		m[r.path] = r.sum
	}

	// check if there was an error reading the file
	if err := <-errc; err != nil {
		// close(done) will signal `sumFiles` that something bad has happened
		return nil, err
	}

	return m, nil
}


func main() {
	m, err := MD5All(os.Args[1])
	if err != nil {
		fmt.Println(err)
		return
	}

	var paths []string
	for path := range m {
		paths = append(paths, path)
	}
	sort.Strings(paths)

	for _, path := range(paths) {
		fmt.Printf("%x  %s\n", m[path], path)
	}
}
