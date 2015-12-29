package main


import (
	"fmt"
	"math/rand"
	"container/heap"
	"time"
)


var nWorker int64 = 10


/*
	Requester
*/
type Request struct {
	fn func() int
	c  chan int
}

func workFn() int {
	fmt.Println("Worked some time...")
	return rand.Int()
}

func requester(work chan<- Request) {
	c := make(chan int)
	for {
		timeUntilRequest := rand.Int63n(nWorker * 2 * int64(time.Second))
		time.Sleep(time.Duration(timeUntilRequest))

		work <- Request{workFn, c}
		result := <-c

		furtherProcess(result)
	}
}

func furtherProcess(result int) {
	fmt.Println("Got result:", result)
}

/*
	Worker
*/
type Worker struct {
	requests chan Request // buffered channel of work to do
	pending int
	index   int 					// index in the heap
}

func (w *Worker) work(done chan *Worker) {
	for {
		req := <-w.requests
		req.c <- req.fn()
		done <- w
	}
}

/*
	Balancer
*/
type Pool []*Worker

func (p Pool) Less(i, j int) bool {
	return p[i].pending < p[j].pending
}

func (p Pool) Len() int {
	return len(p)
}

func (p Pool) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
	p[i].index = j
	p[j].index = i
}


func (p *Pool) Push(x interface{}) {
	n := len(*p)
	w := x.(*Worker)
	w.index = n
	*p = append(*p, w)
}

func (p *Pool) Pop() interface{} {
	old := *p
	n := len(old)
	w := old[n-1]
	w.index = -1
	*p = old[0:n-1]
	return w
}


type Balancer struct {
	pool Pool
	done chan *Worker
}

func (b *Balancer) balance(work chan Request) {
	for {
		select {
		case req := <-work:
			b.dispatch(req)
		case w := <-b.done:
			b.completed(w)
		}
	}
}

func (b *Balancer) dispatch(req Request) {
	w := heap.Pop(&b.pool).(*Worker)
	w.requests <- req
	w.pending++
	heap.Push(&b.pool, w)
}

func (b *Balancer) completed(w *Worker) {
	w.pending--
	heap.Remove(&b.pool, w.index)
	heap.Push(&b.pool, w)
}


/*
  Program entry point
*/
func startRequesters(count int) (chan Request) {
	work := make(chan Request)

	for i := 0; i < count; i++ {
		go requester(work)
	}
	
	return work
}

func startWorkers(count int64) ([]*Worker, chan *Worker) {
	done := make(chan *Worker)
	workers := make([]*Worker, 0)

	for i := int64(0); i < count; i++ {
		rqs := make(chan Request, 3)
		w := Worker{rqs, 0, 0}
		workers = append(workers, &w)
		go w.work(done)
	}

	return workers, done
}

func main() {
	work := startRequesters(30)

	nWorker = 1
	workers, done := startWorkers(nWorker)

	b := Balancer{workers, done}
	b.balance(work)
}
