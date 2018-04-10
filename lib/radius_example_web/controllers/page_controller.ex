defmodule RadiusExampleWeb.PageController do
  use RadiusExampleWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
