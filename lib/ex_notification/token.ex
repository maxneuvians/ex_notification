defmodule ExNotification.Token do
  @moduledoc """
  Generates a JWT token based on the API key defined
  for notification
  """
  use Joken.Config
  @key Application.get_env(:ex_notification, :key)

  @doc """
  Generates a JWT token using the ISS and secret components
  of the Notification API key
  """
  def generate do
    [_iss, secret] = read_key()
    generate_and_sign(%{}, Joken.Signer.create("HS256", secret))
  end

  @impl true
  def token_config do
    [iss, _secret] = read_key()
    default_claims(iss: iss, skip: [:aud])
  end

  defp read_key() do
    [_ | secrets] =
      @key
      |> String.split("-")

    secrets
    |> Enum.chunk_every(5)
    |> Enum.map(&(Enum.join(&1, "-")))
  end
end
