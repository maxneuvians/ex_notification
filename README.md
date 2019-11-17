# ExNotification

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