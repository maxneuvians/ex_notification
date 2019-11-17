defmodule ExNotification.AuthTest do
  use ExUnit.Case

  test "adds a Authorization to a Tesla struct" do
    {:ok, result} = ExNotification.Auth.call(%Tesla.Env{}, [], nil)
    {header, value} = hd(result.headers)
    assert header == "Authorization"
    assert String.contains?(value, "Bearer")
  end
end
