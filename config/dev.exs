use Mix.Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_notification, api: System.get_env("NOTIFICATION_API_URL")
config :ex_notification, key: System.get_env("NOTIFICATION_API_KEY")
