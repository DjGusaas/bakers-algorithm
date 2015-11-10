# Dalton && Otto

defmodule Main do
  def start(n, m) do
    list = []
    mpid = spawn(Manager, :loop, [list])
    :global.register_name(:mpid, mpid)
    mpid
    #distribute_servers(Node.list, n)
    Server.make_servers(n)
    #target_node = List.first(Node.list)
    #npid = Node.spawn(target_node, Server, :make_servers, [n])
    Customer.make_customers(m)
  end
end

defmodule Customer do
  def sleep_customer(pid) do
    send(pid, {:sleep, pid})
  end

  def make_customers(0), do: "All customers created"
	def make_customers(m) when m > 0 do 
    pid = spawn(__MODULE__, :loop, [])
    sleep_customer(pid)
    IO.puts "Customer created"
    make_customers(m-1)
	end

  def loop do
    receive do
      {:sleep, pid} ->
        :timer.sleep(Randomize.random(10000))
        IO.puts "A customer woke up!"
        fib = Randomize.random(40)
        send(:global.whereis_name(:mpid), {:help, pid, fib})
      {:receive, fib} ->
        IO.puts "A customer recieved fib, #{fib}!"
    end
    loop
  end
end

defmodule Server do
	def make_servers(0), do: "All servers created"
  def make_servers(n) when n > 0 do
    target = List.first(Node.list)
    pid = Node.spawn(target, __MODULE__, :loop, [])
    #IO.inspect pid
    #pid = spawn(__MODULE__, :loop, [])
    send(:global.whereis_name(:mpid), {:ready, pid})
    IO.puts "Server created"
    make_servers(n-1)
  end

  def loop do
    #IO.puts "Server is on #{Node.self}!"
    receive do
      {:calculate, pid, fib} ->
        x = Fib.fib(fib)
        IO.inspect Node.self
        send(pid, {:receive, x})
        send(:global.whereis_name(:mpid), {:ready, self()})
    end
    loop
  end

  def distribute_servers(n, nodes) do
    #size = nodes/list_size + 1
    #make_servers(n, self)
  end
end

defmodule Manager do
  def loop(servers) do
		receive	do
			{:help, pid, fib} ->
        first = List.first(servers)
        #IO.puts "Checking for server..."
        if first != nil do
          #IO.puts "Serving a customer"
          send(first, {:calculate, pid, fib})
          servers = List.delete_at(servers, 0)
        else
          #IO.puts "No server, waiting..."
          send(:global.whereis_name(:mpid), {:wait, pid, fib})
        end
      {:ready, pid} ->
        servers = servers ++ [pid]
      {:wait, pid, fib} ->
        #:timer.sleep(500)
        send(:global.whereis_name(:mpid), {:help, pid, fib})
		end
    loop(servers)
	end
end

# This randomize kinda sucks... :{
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
