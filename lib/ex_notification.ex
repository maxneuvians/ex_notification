defmodule ExNotification do
  @moduledoc """
  An elixir client for the notification system APIs used by the Australian, British, and Canadian governments.

  ## Installation

  The package can be installed by adding `ex_notification` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:ex_notification, "~> 0.1.0"}
    ]
  end
  ```

  ## Configuration

  Set the following configuration values in your `config.exs`, setting the `api` value to your API endpoint and the `key` value to your API key. Ex:

  ```
  config :ex_notification, api: "https://localhost"
  config :ex_notification, key: "test-aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee-aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  ```

  ## Documentation

  Documentation can be found at [https://hexdocs.pm/ex_notification](https://hexdocs.pm/ex_notification).

  ## License

  MIT
  """
  alias ExNotification.Client

  @doc """
  Get a notification by ID

  You can filter the returned messages by including the following optional arguments in the URL:

  - `template_type`
  - `status`
  - `reference`
  - `older_than`

  ### Arguments

  You can omit any of these arguments to ignore these filters.

  #### template_type (optional)

  You can filter by:

  * `email`
  * `sms`
  * `letter`

  #### status (optional)

  | status | description | text | email |
  | :--- | :--- | :--- | :--- |
  | created | Notification has placed the message in a queue, ready to be sent to the provider. It should only remain in this state for a few seconds.| Yes | Yes |
  | sending | Notification has sent the message to the provider. The provider will try to deliver the message to the recipient. Notification is waiting for delivery information. | Yes | Yes |
  | delivered | The message was successfully delivered | Yes | Yes |
  | sent / sent internationally | The message was sent to an international number. The mobile networks in some countries do not provide any more delivery information.| Yes | |
  | pending | Notification is waiting for more delivery information.<br>Notification received a callback from the provider but the recipient’s device has not yet responded. Another callback from the provider determines the final status of the notification.| Yes | |
  | failed | This returns all failure statuses:<br>- permanent-failure<br>- temporary-failure<br>- technical-failure | Yes | Yes |
  | permanent-failure | The provider could not deliver the message because the email address or phone number was wrong. You should remove these email addresses or phone numbers from your database. You’ll still be charged for text messages to numbers that do not exist. | Yes | Yes |
  | temporary-failure | The provider could not deliver the message after trying for 72 hours. This can happen when the recipient’s inbox is full or their phone is off. You can try to send the message again. You’ll still be charged for text messages to phones that are not accepting messages. | Yes | Yes |
  | technical-failure | Email / Text: Your message was not sent because there was a problem between Notify and the provider.<br>You’ll have to try sending your messages again. You will not be charged for text messages that are affected by a technical failure. | Yes | Yes |

  #### reference (optional)

  An identifier you can create if necessary. This reference identifies a single notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

  ```
  "reference": "STRING"
  ```

  #### older_than (optional)

  Input the ID of a notification into this argument. If you use this argument, the method returns the next 250 received notifications older than the given ID.

  ```
  "older_than":"740e5834-3a29-46b4-9a6f-16142fde533a"
  ```

  If you leave out this argument, the method returns the most recent 250 notifications.

  The client only returns notifications that are 7 days old or newer. If the notification specified in this argument is older than 7 days, the client returns an empty response.

  ### Response

  If the request is successful, the response body is `json` and the status code is `200`.

  ```
  {
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a", # required string - notification ID
    "reference": "STRING", # optional string - client reference
    "email_address": "sender@something.com",  # required string for emails
    "phone_number": "+447900900123",  # required string for text messages
    "type": "sms / email", # required string
    "status": "sending / delivered / permanent-failure / temporary-failure / technical-failure", # required string
    "template": {
      "version": 1
      "id": 'f33517ff-2a88-4f6e-b855-c550268ce08a' # required string - template ID
      "uri": "/v2/template/{id}/{version}", # required
    },
    "body": "STRING", # required string - body of notification
    "subject": "STRING" # required string for email - subject of email
    "created_at": "STRING", # required string - date and time notification created
    "created_by_name": "STRING", # optional string - name of the person who sent the notification if sent manually
    "sent_at": " STRING", # optional string - date and time notification sent to provider
    "completed_at": "STRING" # optional string - date and time notification delivered or failed
  }
  ```
  """
  def get_notification(
    id,
    template_type \\ nil,
    status \\ nil,
    reference \\ nil,
    older_than \\ nil
  ) do
    case Client.get(
      "/v2/notifications/#{id}",
      query: %{
        template_type: template_type,
        status: status,
        reference: reference,
        older_than: older_than
      }) do
      {:ok, %{body: body}} -> body
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Get a batch of notifications

  This will return all your messages with statuses. They will display in pages of up to 250 messages each.

  You can only get the status of messages that are 7 days old or newer.

  You can filter the returned messages by including the following optional arguments in the URL:

  - `template_type`
  - `status`
  - `reference`
  - `older_than`

  ### Arguments

  You can omit any of these arguments to ignore these filters.

  #### template_type (optional)

  You can filter by:

  * `email`
  * `sms`
  * `letter`

  #### status (optional)

  | status | description | text | email |
  | :--- | :--- | :--- | :--- |
  | created | Notification has placed the message in a queue, ready to be sent to the provider. It should only remain in this state for a few seconds.| Yes | Yes |
  | sending | Notification has sent the message to the provider. The provider will try to deliver the message to the recipient. Notification is waiting for delivery information. | Yes | Yes |
  | delivered | The message was successfully delivered | Yes | Yes |
  | sent / sent internationally | The message was sent to an international number. The mobile networks in some countries do not provide any more delivery information.| Yes | |
  | pending | Notification is waiting for more delivery information.<br>Notification received a callback from the provider but the recipient’s device has not yet responded. Another callback from the provider determines the final status of the notification.| Yes | |
  | failed | This returns all failure statuses:<br>- permanent-failure<br>- temporary-failure<br>- technical-failure | Yes | Yes |
  | permanent-failure | The provider could not deliver the message because the email address or phone number was wrong. You should remove these email addresses or phone numbers from your database. You’ll still be charged for text messages to numbers that do not exist. | Yes | Yes |
  | temporary-failure | The provider could not deliver the message after trying for 72 hours. This can happen when the recipient’s inbox is full or their phone is off. You can try to send the message again. You’ll still be charged for text messages to phones that are not accepting messages. | Yes | Yes |
  | technical-failure | Email / Text: Your message was not sent because there was a problem between Notify and the provider.<br>You’ll have to try sending your messages again. You will not be charged for text messages that are affected by a technical failure. | Yes | Yes |

  #### reference (optional)

  An identifier you can create if necessary. This reference identifies a single notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

  ```
  "reference": "STRING"
  ```

  #### older_than (optional)

  Input the ID of a notification into this argument. If you use this argument, the method returns the next 250 received notifications older than the given ID.

  ```
  "older_than":"740e5834-3a29-46b4-9a6f-16142fde533a"
  ```

  If you leave out this argument, the method returns the most recent 250 notifications.

  The client only returns notifications that are 7 days old or newer. If the notification specified in this argument is older than 7 days, the client returns an empty response.

  ### Response

  If the request is successful, the response body is `json` and the status code is `200`.

  ```
  {
    "notifications": [
      {
        "id": "740e5834-3a29-46b4-9a6f-16142fde533a", # required string - notification ID
        "reference": "STRING", # optional string - client reference
        "email_address": "sender@something.com",  # required string for emails
        "phone_number": "+447900900123",  # required string for text messages
        "type": "sms / email", # required string
        "status": "sending / delivered / permanent-failure / temporary-failure / technical-failure", # required string
        "template": {
          "version": 1
          "id": 'f33517ff-2a88-4f6e-b855-c550268ce08a' # required string - template ID
          "uri": "/v2/template/{id}/{version}", # required
        },
        "body": "STRING", # required string - body of notification
        "subject": "STRING" # required string for email - subject of email
        "created_at": "STRING", # required string - date and time notification created
        "created_by_name": "STRING", # optional string - name of the person who sent the notification if sent manually
        "sent_at": " STRING", # optional string - date and time notification sent to provider
        "completed_at": "STRING" # optional string - date and time notification delivered or failed
      },
      …
    ],
    "links": {
      "current": "/notifications?template_type=sms&status=delivered",
      "next": "/notifications?other_than=last_id_in_list&template_type=sms&status=delivered"
    }
  }
  ```
  """
  def get_notifications(
    template_type \\ nil,
    status \\ nil,
    reference \\ nil,
    older_than \\ nil
  ) do
    case Client.get(
      "/v2/notifications",
      query: %{
        template_type: template_type,
        status: status,
        reference: reference,
        older_than: older_than
      }) do
      {:ok, %{body: body}} -> body
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Send email message.

  ### Arguments

  #### email_address (required)

  The email address of the recipient.

  #### template_id (required)

  Sign in to [Notification](https://notification.alpha.canada.ca) and go to the __Templates__ page to find the template ID.

  #### personalisation (optional)

  If a template has placeholder fields for personalised information such as name or reference number, you need to provide their values in a dictionary with key value pairs. For example:

  ```
  "personalisation": %{
    "first_name": "Amala",
    "application_date": "2018-01-01",
  }
  ```
  You can leave out this argument if a template does not have any placeholder fields for personalised information.

  #### reference (optional)

  An identifier you can create if necessary. This reference identifies a single notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

  ```
  "reference": "STRING"
  ```
  You can leave out this argument if you do not have a reference.

  #### email_reply_to_id (optional)

  This is an email reply-to address specified by you to receive replies from your users. Your service cannot go live until you set up at least one of these email addresses. To set up:

  1. Sign into your Notification account.
  1. Go to __Settings__.
  1. If you need to change to another service, select __Switch service__ in the top right corner of the screen and select the correct one.
  1. Go to the Email section and select __Manage__ on the __Email reply-to addresses__ row.
  1. Select __Change__ to specify the email address to receive replies, and select __Save__.

  For example:

  ```
  "email_reply_to_id": "8e222534-7f05-4972-86e3-17c5d9f894e2"
  ```

  You can leave out this argument if your service only has one email reply-to address, or you want to use the default email address.

  ## Send a file by email

  Send files without the need for email attachments.

  This is an invitation-only feature. [Contact the Notification team](https://notification.alpha.canada.ca/support/ask-question-give-feedback) to enable this function for your service.

  To send a file by email, add a placeholder field to the template then upload a file. The placeholder field will contain a secure link to download the file.

  #### Add a placeholder field to the template

  1. Sign in to [Notification](https://notification.alpha.canada.ca/).
  1. Go to the __Templates__ page and select the relevant email template.
  1. Add a placeholder field to the email template using double brackets. For example:

  "Download your file at: ((link_to_document))"

  #### Upload your file

  The file you upload must be a PDF file smaller than 2MB. You’ll need to convert the file into a string that is base64 encoded.

  Pass the file object as a value into the personalisation argument. For example:

  ```
  "personalisation":{
    "first_name": "Amala",
    "application_date": "2018-01-01",
    "link_to_document": "file as base64 encoded string",
  }
  ```

  ### Response

  If the request to the client is successful, the client returns a `dict`:

  ```
  {
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a",
    "reference": "STRING",
    "content": {
      "subject": "SUBJECT TEXT",
      "body": "MESSAGE TEXT",
      "from_email": "SENDER EMAIL"
    },
    "uri": "https://api.notification.alpha.canada.ca/v2/notifications/740e5834-3a29-46b4-9a6f-16142fde533a",
    "template": {
      "id": "f33517ff-2a88-4f6e-b855-c550268ce08a",
      "version": 1,
      "uri": "https://api.notification.alpha.canada.ca/v2/template/f33517ff-2a88-4f6e-b855-c550268ce08a"
    }
  }
  ```
  """
  def send_email(
    email_address,
    template_id,
    personalisation \\ %{},
    reference \\ nil,
    email_reply_to_id \\ nil)
  do
    case Client.post(
      "/v2/notifications/email",
      %{
        email_address: email_address,
        template_id: template_id,
        personalisation: personalisation,
        reference: reference,
        email_reply_to_id: email_reply_to_id
      })
    do
      {:ok, %{body: body}} -> body
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Send sms message.

  #### phone_number (required)

  The phone number of the recipient of the text message. This can be a Canadian or international number.

  #### template_id (required)

  Sign in to [Notification](https://notification.alpha.canada.da/) and go to the __Templates__ page to find the template ID.

  #### personalisation (optional)

  If a template has placeholder fields for personalised information such as name or reference number, you must provide their values in a dictionary with key value pairs. For example:

  ```
  "personalisation": {
    "first_name": "Amala",
    "application_date": "2018-01-01",
  }
  ```

  You can leave out this argument if a template does not have any placeholder fields for personalised information.

  #### reference (optional)

  An identifier you can create if necessary. This reference identifies a single notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

  ```
  "reference": "STRING"
  ```

  You can leave out this argument if you do not have a reference.

  #### sms_sender_id (optional)

  A unique identifier of the sender of the text message notification. You can find this information on the __Text Message sender__ settings screen:

  1. Sign into your Notification account.
  1. Go to __Settings__.
  1. If you need to change to another service, select __Switch service__ in the top right corner of the screen and select the correct one.
  1. Go to the __Text Messages__ section and select __Manage__ on the __Text Message sender__ row.

  You can then either:

  - copy the sender ID that you want to use and paste it into the method
  - select __Change__ to change the default sender that the service will use, and select __Save__

  ```
  "sms_sender_id": "8e222534-7f05-4972-86e3-17c5d9f894e2"
  ```

  You can leave out this argument if your service only has one text message sender, or if you want to use the default sender.

  ### Response

  If the request is successful, the response body is `json` with a status code of `201`:

  ```
  {
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a",
    "reference": "STRING",
    "content": {
      "body": "MESSAGE TEXT",
      "from_number": "SENDER"
    },
    "uri": "https://api.notification.alpha.canada.ca/v2/notifications/740e5834-3a29-46b4-9a6f-16142fde533a",
    "template": {
      "id": "f33517ff-2a88-4f6e-b855-c550268ce08a",
      "version": 1,
      "uri": "https://api.notification.alpha.canada.ca/v2/template/ceb50d92-100d-4b8b-b559-14fa3b091cd"
    }
  }
  ```

  If you are using the test API key, all your messages will come back with a `delivered` status.

  All messages sent using the team and whitelist or live keys will appear on your dashboard.
  """
  def send_sms(
    phone_number,
    template_id,
    personalisation \\ %{},
    reference \\ nil,
    sms_sender_id \\ nil)
  do
    case Client.post(
      "/v2/notifications/sms",
      %{
        phone_number: phone_number,
        template_id: template_id,
        personalisation: personalisation,
        reference: reference,
        sms_sender_id: sms_sender_id
      })
    do
      {:ok, %{body: body}} -> body
      {:error, error} -> {:error, error}
    end
  end
end
