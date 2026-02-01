defmodule Procs do
  def hello(count) do
    receive do
      {:quit} ->
        IO.puts("I'm outta here")

      {:reset} ->
        hello(0)

      {:add, n} ->
        hello(count + n)

      msg ->
        IO.puts("#{count}: hello #{inspect(msg)}")
        hello(count + 1)
    end
  end
end
