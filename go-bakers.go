package main

import "fmt"

func main() {
	// {1, 45}
	// a customer is an identifying number and 
	// a desired fibonacci number
	//customers = make_customers(10)

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

func make_customers(n int) []struct {
	custs := []struct
	for i:=0; i < n; i++{
		cust = customer{i, rand.Intn(40)}
		custs = append(custs, cust)
	}
	return custs
}
