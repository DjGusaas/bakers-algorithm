# Bailey && Dalton

defmodule Customer do
  def print_customer(n) do
		IO.puts "Customer #{n} arrived at store."
	end

	def make_customers(0), do: "Finished creating customers."
	def make_customers(n) when n > 0 do
		spawn(__MODULE__, :print_customer, [n])
		#send
		make_customers(n-1)
		#receive do
			#{:sleep } -> this-customer.sleep(:random.uniform()
			#{:line
			# sleep for :random.uniform(1000)
			# fib :random.uniform(40)
			# make-customers(n-1)
		#end
	end

	#def customer(n) do
	#	IO.puts "n #{n}}
	#end
end
