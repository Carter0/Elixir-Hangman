defmodule Chain do
  ## A little test module for checking out programming with elixir nodes.
  ## Nodes are created whenever you run iex from your terminal.
  ## You can communicate across nodes from your computer, and even other computers
  ## across the world.
  defstruct(next_node: nil, count: 4)

  def start_link(next_node) do
    pid = spawn_link(Chain, :message_loop, [%Chain{next_node: next_node}])
    Process.register(pid, :chainer)
  end

  def message_loop(%{count: 0}), do: IO.puts("done")

  def message_loop(state) do
    receive do
      {:trigger, list} ->
        IO.inspect(list)
        :timer.sleep(500)
        send({:chainer, state.next_node}, {:trigger, [node() | list]})
    end

    message_loop(%{state | count: state.count - 1})
  end
end
