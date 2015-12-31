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

func psprint(F ps) {
	for ; ; {
		select {
		case el := <-F:
			asString := el.FloatString(50)
			fmt.Println(asString)
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

func psderiv(F ps) ps {
	D := psmk()

	go func() {
		<-F
		var n int64 = 1
		for {
			f := <-F
			D <- *big.NewRat(n * f.Num().Int64(), f.Denom().Int64())
			n++
		}
	}()

	return D
}


func fact(n int64) *big.Int {
	if n == 0 {
		return big.NewInt(1)
	}

	next := fact(n - 1)
	return next.Mul(next, big.NewInt(n))
}


func psExp(x float64) ps {
	F := psmk()

	go func(x float64) {
		var i int64
		for i = 0; ; i++ {
			num := big.NewInt(int64(math.Pow(x, float64(i))))
			den := fact(i)
			F <- *(big.NewRat(1, 1).SetFrac(num, den))
		}

		close(F)
	}(x)

	return F
}

func psOnes() ps {
	Ones := psmk()

	go func() {
		one := big.NewRat(1, 1)
		for {
			Ones <- *one
		}
	}()

	return Ones
}

func main() {
//	F := psExp(1.0)
//	G := psExp(1.0)
//
//	S := psadd(F, G)
//	D := psderiv(F)
	Ones := psOnes()

	psprint(psderiv(Ones))
}
