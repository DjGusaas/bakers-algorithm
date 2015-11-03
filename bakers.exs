# Bailey && Dalton && Dillon

defmodule Main do
  def start(cst) do
    pid = spawn(&Manager.handle_things/0)
    Customer.make_customers(cst, pid)
    #Server.make_servers(svr, pid)
  end
end

defmodule Customer do
  def sleep_customer(n, pid) do
    IO.puts "Customer #{n} arrived at store."
    :timer.sleep(Randomize.random(10000))
    fib = Randomize.random(40)
    send(pid, {:help, n, self(), fib})
	end

  def make_customers(0, _), do: "Customers created"
	def make_customers(n, pid) when n > 0 do 
    spawn(__MODULE__, :sleep_customer, [n, pid])

		make_customers(n-1, pid)
	end

  def loop do
    receive do
      {:loop, sender_num} ->
        IO.puts "Yay! Customer #{sender_num}"
    end
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
	def handle_things do
		receive	do
			{:help, sender_num, pid, fib} ->
		    send(pid, {:loop, sender_num})
      {:ready, sender_num, pid} ->
        IO.inspect pid
		end
    handle_things
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
