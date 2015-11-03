# Bailey && Dalton && Dillon

defmodule Main do
  def start(n) do
    mpid = spawn(&Manager.loop/0)
    cpid = spawn(&Customer.loop/0)
    spid = spawm(&Server.loop/0)
    Process.register(mpid, :mpid)
    mpid
    Process.register(cpid, :cpid)
    cpid
    Process.register(spid, :spid)
    spid
    Customer.make_customers(n)
    #Server.make_servers()
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
      {:loop, n, fib} ->
        IO.puts "Yay! Customer #{n}"
    end
    loop
  end
end

defmodule Server do
  def send_server(n, pid) do
    IO.puts "Server #{n} is getting ready"
    send(pid, {:ready, n, self()})
  end

	def make_servers(0, _), do: "Servers created"
  def make_servers(n, pid) when n > 0 do
    spawn(__MODULE__, :send_server, [n, pid])

    make_servers(n-1, pid)
  end
end

defmodule Manager do
	def loop do
		receive	do
			{:help, n, pid, fib} ->
		    send(:cpid, {:loop, n, fib})
      {:ready, sender_num, pid} ->
        IO.inspect pid
		end
    loop
	end
end

defmodule Randomize do
  def random(number) do
    :random.seed(:erlang.now())
    :random.uniform(number)
   end
end

defmodule Fib do

end
