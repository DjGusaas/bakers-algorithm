# Bailey && Dalton && Dillon

defmodule Customer do
  def sleep_customer(n, pid) do
    IO.puts "Customer #{n} arrived at store."
    :timer.sleep(Randomize.random(10000))
    fib = Randomize.random(40)
    send(pid, {:help, n, self(), fib})
	end

  def make_customers(0, _), do: "Finished making customers"
	def make_customers(n, pid) when n > 0 do 
    spawn(__MODULE__, :sleep_customer, [n, pid])

		make_customers(n-1, pid)
	end
end

defmodule Server do
  def send_server(n, pid) do
    IO.puts "Sending server #{n}."
    send(pid, {:ready, n, self()})
  end

	def make_servers(0, _), do: "Finished making servers"
  def make_servers(n, pid) when n > 0 do
    spawn(__MODULE__, :send_server, [n, pid])

    make_servers(n-1, pid)
  end
end

defmodule Manager do
	def handle_things do
		receive	do
			{:help, sender_id, sender, fib} -> IO.puts "Customer #{sender_id} received, fib: #{fib}"
			{:ready, sender_id, sender} -> IO.inspect sender #"Server #{sender} received"
		end
    handle_things
	end

  def customer_line(pid, fib) do
    if 1==1 do # if a server is open
            
    else
      customer_line(pid, fib)
    end
  end
end

defmodule Randomize do
  def random(number) do
    :random.seed(:erlang.now())
    :random.uniform(number)
   end
end
