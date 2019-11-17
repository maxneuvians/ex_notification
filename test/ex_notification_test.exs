defmodule ExNotificationTest do
  use ExUnit.Case
  import Tesla.Mock


  @url Application.get_env(:ex_notification, :api)

  setup do
    mock fn
      # Get Notification
      %{method: :get, url: @url <> "/v2/notifications/abcd"} ->
        json(%{"my" => "notification"})

      # Get Notifications
      %{method: :get, url: @url <> "/v2/notifications"} ->
        json([%{"my" => "notification"}])

      # Send email
      %{method: :post, url: @url <> "/v2/notifications/email"} ->
        json(%{"my" => "notification"})

      # Send sms
      %{method: :post, url: @url <> "/v2/notifications/sms"} ->
        json(%{"my" => "notification"})
    end

    :ok
  end

  test "get_notification/1 return a map on success" do
    assert ExNotification.get_notification("abcd") == %{"my" => "notification"}
  end

  test "get_notifications/0 return a list of maps on success" do
    assert ExNotification.get_notifications() == [%{"my" => "notification"}]
  end

  test "send_email/2 return a map on success" do
    assert ExNotification.send_email("foo", "bar") == %{"my" => "notification"}
  end

  test "send_sms/2 return a map on success" do
    assert ExNotification.send_sms("foo", "bar") == %{"my" => "notification"}
  end
end
