package main

import (
	"fmt"
	"sync"
	"time"
)

func elapsed() func() {
	start := time.Now()
	return func() {
		fmt.Println("took", time.Since(start))
	}
}

func cpuHeavy() {
	for n := 0; n < 20_000; n++ {
		a, b := 0, 1
		for i := 0; i < n; i++ {
			a, b = b, a+b
		}
	}
}

func launchGoRoutines(num int) {
	var wg sync.WaitGroup
	wg.Add(num + 1)

	for i := 0; i < num; i++ {
		go func() {
			defer wg.Done()
			cpuHeavy()
		}()
	}

	wg.Wait()
}

func main() {
	defer elapsed()()

	// runtime.GOMAXPROCS(1)

	launchGoRoutines(32)
}
