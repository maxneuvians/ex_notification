defmodule ExNotification.Client do
  @moduledoc """
  Elixir API client using Tesla
  """
  use Tesla, only: ~w(get post)a

  plug Tesla.Middleware.BaseUrl, Application.get_env(:ex_notification, :api)
  plug ExNotification.Auth
  plug ExNotification.Format
  plug Tesla.Middleware.JSON
end
