package main

import (
	"fmt"
	"math/rand"
)

func main() {
	// {1, 45}
	// a customer is an identifying number and 
	// a desired fibonacci number
	customers := make_customers(10)
	fmt.Println(customers)
	
	//chan := make(chan customer)
	//chan <- customers[1]
	//v := <-chan
	//fmt.Println(v)
	//
	//servers = make_servers(2)

	//
	//start_serving(customers, servers)
}

type customer struct {
	id int
	fib int
}

func fib(a int) int {
	if a < 2 {
		return a
	}
	return fib(a - 1) + fib(a - 2)
}

func make_customers(n int) []customer {
	custs := []customer{}
	for i:=0; i < n; i++{
		cust := customer{i, rand.Intn(40)}
		custs = append(custs, cust)
	}
	return custs
}
