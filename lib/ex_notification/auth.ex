defmodule ExNotification.Auth do
  @moduledoc """
  Middleware to add the JWT Bearer token to the request
  """
  @behaviour Tesla.Middleware

  @doc """
  Creates a new JWT token and injects it in as a header to
  the request
  """
  def call(env, next, _) do
    {:ok, token, _} = ExNotification.Token.generate()
    env
    |> Tesla.put_headers([{"Authorization", "Bearer " <> token}])
    |> Tesla.run(next)
  end
end
