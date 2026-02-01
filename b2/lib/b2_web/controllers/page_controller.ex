defmodule B2Web.PageController do
  use B2Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
