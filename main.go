package main

import (
	"fmt"
	"math/rand"
)

func main() {
	const probability = 0.03

	var address *uint

	for i := 0; i < 1000; i++ {
		zero := uint(0)

		mustBreak := rand.Float64() < probability
		address = &zero

		if mustBreak {
			break
		}
	}

	fmt.Printf("%p\n", address)
}
