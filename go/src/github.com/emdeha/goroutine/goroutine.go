package main

import (
	"fmt"
	"sync"
)

type Fetcher interface {
	// Fetch returns the body of URL and
	// a slice of URLs found on that page.
	Fetch(url string) (body string, urls []string, err error)
}

func IsIn(visited []string, url string) bool {
	for _, v := range visited {
		if v == url {
			return true
		}
	}
	
	return false
}

var found = struct {
	sync.RWMutex
	f []string
}{f: make([]string, 1)}

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl(url string, depth int, fetcher Fetcher, ready chan string) {
	defer func () {
		ready <- url
	}()

	if depth <= 0 {
		return
	}
	
	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)
		return
	}
	
	fmt.Printf("found: %s %q\n", url, body)
	
	childrenCount := 0
	found.RLock()
	for _, u := range urls {
		if !IsIn(found.f, u) {
			childrenCount += 1
		}
	}
	found.RUnlock()
	
	readyChildren := make(chan string, childrenCount)
	for _, u := range urls {
		found.RLock()
		if !IsIn(found.f, u) {
			found.RUnlock()
			found.Lock()
			found.f = append(found.f, u)
			found.Unlock()
			go Crawl(u, depth-1, fetcher, readyChildren)
		} else {
			found.RUnlock()
		}
	}
	
	for i:=0; i<childrenCount; i++ {
		<-readyChildren
	}
	
	return
}

func main() {
	ready := make(chan string, 1)
	found.f = append(found.f, "http://golang.org/")
	Crawl("http://golang.org/", 4, fetcher, ready)
	<-ready
}

// fakeFetcher is Fetcher that returns canned results.
type fakeFetcher map[string]*fakeResult

type fakeResult struct {
	body string
	urls []string
}

func (f fakeFetcher) Fetch(url string) (string, []string, error) {
	if res, ok := f[url]; ok {
		return res.body, res.urls, nil
	}
	return "", nil, fmt.Errorf("not found: %s", url)
}

// fetcher is a populated fakeFetcher.
var fetcher = fakeFetcher{
	"http://golang.org/": &fakeResult{
		"The Go Programming Language",
		[]string{
			"http://golang.org/pkg/",
			"http://golang.org/cmd/",
		},
	},
	"http://golang.org/pkg/": &fakeResult{
		"Packages",
		[]string{
			"http://golang.org/",
			"http://golang.org/cmd/",
			"http://golang.org/pkg/fmt/",
			"http://golang.org/pkg/os/",
		},
	},
	"http://golang.org/pkg/fmt/": &fakeResult{
		"Package fmt",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
	"http://golang.org/pkg/os/": &fakeResult{
		"Package os",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
}

