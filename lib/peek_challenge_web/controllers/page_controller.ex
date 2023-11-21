defmodule PeekChallengeWeb.PageController do
  use PeekChallengeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
