defmodule ExNotification.Format do
  @moduledoc """
  Middleware to format the body of the request
  """
  @behaviour Tesla.Middleware

  @doc """
  Loops through the body and removes and params that have
  no content
  """
  def call(env = %{body: %{}}, next, _) do
    body =
      env.body
      |> Enum.filter(fn {_k, v} -> v != nil end)
      |> Enum.into(%{})

      %{env | body: body}
    |> Tesla.run(next)
  end

  @doc """
  Loops through the query and removes and params that have
  no content
  """
  def call(env = %{query: %{}}, next, _) do
    query =
      env.query
      |> Enum.filter(fn {_k, v} -> v != nil end)
      |> Enum.into(%{})

    %{env | query: query}
    |> Tesla.run(next)
  end
end
