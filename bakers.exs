# Bailey && Dalton && Dillon

defmodule Main do
  def start(n, m) do
    list = []
    mpid = spawn(Manager, :loop, [list])
    cpid = spawn(&Customer.loop/0)
    spid = spawn(&Server.loop/0)
    Process.register(mpid, :mpid)
    mpid
    Process.register(cpid, :cpid)
    cpid
    Process.register(spid, :spid)
    spid
    Server.make_servers(n)
    Customer.make_customers(m)
  end
end

defmodule Customer do
  def sleep_customer(n) do
    IO.puts "Customer #{n} arrived at store."
    :timer.sleep(Randomize.random(10000))
    fib = Randomize.random(40)
    send(:mpid, {:help, n, self(), fib})
  end

  def make_customers(0), do: "Customers created"
	def make_customers(n) when n > 0 do 
    spawn(__MODULE__, :sleep_customer, [n])

		make_customers(n-1)
	end

  def loop do
    receive do
      {:recieve, n, fib} ->
        IO.puts "Customer #{n} recieved their fib, #{fib}!"
    end
    loop
  end
end

defmodule Server do
  def ready_server(pid) do
    send(:mpid, {:ready, pid})
  end
  def ready_servers() do
    IO.puts "A server is ready"
    send(:mpid, {:ready, self()})
  end

	def make_servers(0), do: "Servers created"
  def make_servers(n) when n > 0 do
    spawn(__MODULE__, :ready_servers, [])

    make_servers(n-1)
  end

  def loop do
    receive do
      {:calculate, n, fib, server} ->
        x = Fib.fib(fib)
        send(:cpid, {:recieve, n, x})
        ready_server(server)
    end
    loop
  end
end

defmodule Manager do
	def loop(list) do
		receive	do
			{:help, n, pid, fib} ->
        first = List.first(list)
        IO.puts "Checking for server..."
        if first != nil do
          IO.puts "Serving customer #{n}"
          send(:spid, {:calculate, n, fib, first})
          list = List.delete_at(list, 0)
        else
          IO.puts "No server, waiting..."
          send(:mpid, {:wait, n, pid, fib})
        end
      {:ready, pid} ->
        list = list ++ [pid]
        IO.inspect list
      {:wait, n, pid, fib} ->
        :timer.sleep(500)
        "Done waiting..."
        send(:mpid, {:help, n, pid, fib})
		end
    loop(list)
	end
end

defmodule Randomize do
  def random(number) do
    :random.seed(:erlang.now())
    :random.uniform(number)
  end
end

defmodule Fib do
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end
