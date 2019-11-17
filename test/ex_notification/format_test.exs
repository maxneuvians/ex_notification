defmodule ExNotification.FormatTest do
  use ExUnit.Case

  test "filters out any nil values in body params" do
    env = %Tesla.Env{body: %{foo: "bar", fizz: nil}}
    {:ok, result} = ExNotification.Format.call(env, [], nil)
    assert result.body == %{foo: "bar"}
  end

  test "filters out any nil values in query params" do
    env = %Tesla.Env{query: %{foo: "bar", fizz: nil}}
    {:ok, result} = ExNotification.Format.call(env, [], nil)
    assert result.query == %{foo: "bar"}
  end
end
