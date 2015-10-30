# Bailey && Dalton && Dillon

defmodule Customer do
  def sleep_customer(n, pid) do
  #    IO.puts "CPID: #{cpid}"
    IO.puts "Customer #{n} arrived at store."
    :timer.sleep(Randomize.random(10000))
    send(pid, {:test, "test"})
	end

	def make_customers(0, _), do: "Finished creating customers."
	def make_customers(n, pid) when n > 0 do
		spawn(__MODULE__, :sleep_customer, [n, pid])
    IO.puts "#{self()}"

		make_customers(n-1, pid)
	end
end

defmodule Server do
		
end

defmodule Manager do
	def handle_things do
		receive	do
			{:test, sender} -> IO.puts "Customer #{sender} received"
			#{:help, sender} customer
			#{:ready, sender} server
      handle_things
		end
	end
end

defmodule Randomize do
  def random(number) do
    :random.seed(:erlang.now())
    :random.uniform(number)
   end
end
