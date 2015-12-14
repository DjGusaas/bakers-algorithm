// by Thomas Harren && Josh Chapman && Dalton Gusaas
// original repo: https://github.com/chapm250/BakersGo.git
package main

import (
  "fmt"
  "sync"
  "time"
  "math/rand"
)

type customer struct {
	id int
	fib int
}

//Compile and run from terminal using `go build BakersGo.go && ./BakersGo`
//Good variables (in order): 10,3,20,40+10

//Alternatively paste and run at play.golang.org
//Good variables (in order): 10,2,2,10+29

//To modify variables:
//==> numCustomers: edit directly
//==> number of Servers:
// -------> In main, duplicate line `resultChanX := serialServer(waitingCustomers)``
// -------> and add it to merge(... ... resultChanX)
//==> customer sleep time: edit the `delay` in makeRandomCustomers(count int)
//==> customer fib range: edit the `fibNum` in makeRandomCustomers(count int)

func main() {
  numCustomers := 10;
  // Generate required amount of customers by spawing numCustomers goroutines.
  // When customers wake up, they will add themselves to the waitingCustomers channel.
  waitingCustomers := makeRandomCustomers(numCustomers)

  // Distribute the fib work across goroutines that read from waitingCustomers.
  // Each server writes results, as they are found, to it's own channel (of type customer).
  resultChan1 := serialServer(waitingCustomers)
  resultChan2 := serialServer(waitingCustomers)

  //A resultChan that merges what is forwarded from each individual resultChan
  allResults := merge(resultChan1,
                      resultChan2)

  //Print out all numCustomers results as they come in from any respective channel.
  for i := 0; i < numCustomers; i++ {
    result := <-allResults
    fmt.Printf("%d=======>The result is %d!!!\n", result.id, result.fib)
  }
}

func makeRandomCustomers(count int) <-chan customer {
    awakeCustomers := make(chan customer)

    //Kick off goroutines and return the new (likely empty) channel imediately.
    //Coustomers will add themselves to awakeCustomers channel as they awaken.
    for i := 0; i < count; i++ {
      go func(index int) {
        fmt.Printf("Initialising customer %d\n",index)
        delay := time.Duration(rand.Intn(2))*time.Second
        fibNum := rand.Intn(10)+29;
        time.Sleep(delay)
        fmt.Printf("%d~>Done sleeping. Please calculate fib(%d) ASAP!\n",index, fibNum)
        awakeCustomers <- customer{index, fibNum} //Passing a random number to get fib-ed
      }(i)//pass in a copy of index so we can keep track of customer id
    }
    return awakeCustomers
}

func serialServer(awakeCustomers <-chan customer) <-chan customer {
    out := make(chan customer)
    go func() {
        for n := range awakeCustomers {
            fmt.Printf("%d--->Calculating fib of %d\n", n.id, n.fib)
            out <- customer{n.id, fib(n.fib)}
            fmt.Printf("%d=====>Done calculating fib(%d). Printing momentarily...\n", n.id, n.fib)
	}
        close(out)
    }()
    return out
}

//combines all resultChan on the fly using 'fan-in' from https://blog.golang.org/pipelines
func merge(cs ...<-chan customer) <-chan customer {
    var wg sync.WaitGroup
    out := make(chan customer)

    // Start an output goroutine for each input channel in cs.  output
    // copies values from c to out until c is closed, then calls wg.Done.
    output := func(c <-chan customer) {
        for n := range c {
            out <- n
        }
        wg.Done()//wg--
    }
    wg.Add(len(cs))//wg++, but incremnts all at once here
    for _, v := range cs {//loop gets k,v pairs: key unused, value is v
        go output(v)
    }

    // Start a goroutine to close out once all the output goroutines are
    // done.  This must start after the wg.Add call. (Otherwise wait would pass)
    go func() {
        wg.Wait()//is wg==0 yet?
        close(out)
    }()
    return out
}



func fib(a int) int {
	if a < 2 {
		return a
	}
	return fib(a - 1) + fib(a - 2)
}

