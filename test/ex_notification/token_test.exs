defmodule ExNotification.TokenTest do
  use ExUnit.Case

  setup do
    [_ | secrets] =
      Application.get_env(:ex_notification, :key)
      |> String.split("-")

    [_iss, secret] =
      secrets
      |> Enum.chunk_every(5)
      |> Enum.map(&(Enum.join(&1, "-")))
    %{signer: Joken.Signer.create("HS256", secret)}
  end

  test "generates a JWT based on the API key", %{signer: signer} do
    {:ok, token, params} = ExNotification.Token.generate()
    assert ExNotification.Token.verify_and_validate(token, signer) == {:ok, params}
  end
end
