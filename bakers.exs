#Bailey && Dalton


#defmodule Test do
#	def tessst(n), do: IO.puts "#{n} alsdkf"	
#end

defmodule Customer do
	def make-customers(n) do
		spawn(&Customer.customer/0)
		#send  
		make-cusomters(n-1)
		#receive do
			#{:sleep } -> this-customer.sleep(:random.uniform()
			#{:line
			# sleep for :random.uniform(1000)
			# fib :random.uniform(40)
			# make-customers(n-1)
		#end
	end

	def customer do
		IO.puts "hello"
	end
end


defmodule Servers do

end
