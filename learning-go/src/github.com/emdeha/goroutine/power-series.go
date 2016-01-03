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
	for {
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


func pscmul(f big.Rat, F ps) ps {
	M := psmk()

	go func() {
		for {
			g := <-F
			M <- *f.Mul(&f, &g)
		}
	}()

	return M
}

func psxmul(F ps) ps {
	M := psmk()

	go func() {
		M <- *big.NewRat(0, 1)
		for {
			f := <-F
			M <- f
		}
	}()

	return M
}

type pspair [2]ps

func pspairmk(F, G ps) pspair {
	return [2]ps{F, G}
}

func doSplit(F, F0, F1 ps) {
	f := <-F
	H := psmk()
	select {
	case F0 <- f:
		go doSplit(F, F0, H)
		F1 <- f

		pscopy(H, F1)
		return
	case F1 <- f:
		go doSplit(F, H, F1)
		F0 <- f

		pscopy(H, F0)
		return
	}
}

func pscopy(F, C ps) {
	for {
		C <- <-F
	}
}

func split(F ps) pspair {
	FF := pspairmk(psmk(), psmk())

	go doSplit(F, FF[0], FF[1])
	
	return FF
}

func psmul(F, G ps) ps {
	M := psmk()

	go func() {
		f := <-F
		g := <-G
		f.Mul(&f, &g)
		M <- f
		FF := split(F)
		GG := split(G)
		fG := pscmul(f, GG[0])
		gF := pscmul(g, FF[0])
		xFG := psxmul(psmul(FF[1], GG[1]))
		for {
			fg := <-fG
			gf := <-gF
			xfg := <- xFG
			fg.Add(&fg, &gf)
			fg.Add(&fg, &xfg)
			M <- fg
		}
	}()

	return M
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
	F := psExp(1.0)
	G := psExp(1.0)
//
//	S := psadd(F, G)
//	D := psderiv(F)
//	Ones := psOnes()

	psprint(psmul(F, G))
}
