defmodule TextClient do
  @spec start() :: :ok
  def start do
    connection = TextClient.Runtime.RemoteHangman.connect()
    TextClient.Impl.Player.start(connection)
  end
end
