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


func sumFiles(done <-chan struct{}, root string) (<-chan result, <-chan error) {
	c := make(chan result)
	errc := make(chan error, 1)

	go func() {
		var wg sync.WaitGroup
		err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.Mode().IsRegular() {
				return nil
			}

			wg.Add(1)

			go func() {
				data, err := ioutil.ReadFile(path)
				select {
				case c <- result{path, md5.Sum(data), err}:
				case <-done:
				}
				wg.Done()
			}()

			// Abort if done is closed
			select {
			case <-done:
				return errors.New("Walk closed")
			default:
				return nil
			}
		})

		// Close `c` after all walks have been either finished or disrupted
		go func() {
			wg.Wait()
			close(c)
		}()

		errc <- err
	}()

	return c, errc
}

func MD5All(root string) (map[string][md5.Size]byte, error) {
	// `done` communicates that there was either an error during parsing
	// or MD5All has walked all the files in the directory
	done := make(chan struct{})
	defer close(done)

	c, errc := sumFiles(done, root)

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
