package main


import (
	"fmt"
	"math/big"
	"math"
)


type ps chan big.Rat


func psmk() ps {
	ps := make(chan big.Rat)
	return ps
}

func psprint(F ps, done chan struct{}) {
	for {
		select {
		case el := <-F:
			fmt.Println(*el.Num(), *el.Denom())
		case <-done:
			return
		}
	}
}

func psadd(F, G ps) ps {
	S := psmk()

	go func() {
		for {
			var sum big.Rat
			f := <-F
			g := <-G
			sum.Add(&f, &g)
			S <- sum
		}
	}()

	return S
}


func fact(n int64) int64 {
	if n == 0 {
		return 1
	}

	return n * fact(n - 1)
}


func main() {
	F := psmk()
	done := make(chan struct{})

	go func(n int64, x float64) {
		var i int64
		for i = 0; i < n; i++ {
			num := int64(math.Pow(x, float64(i)))
			den := fact(i)
			F <- *big.NewRat(num, den)
		}

		close(done)
	}(30, 1.0)

	psprint(F, done)
}
