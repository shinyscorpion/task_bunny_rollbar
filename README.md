# TaskBunnyRollbar

TaskBunny failure backend for Rollbar.

## Installation

```elixir
def deps do
  [{:task_bunny_rollbar, "~> 0.1.0"}]
end
```

## Sample configuration

```elixir
config :rollbax,
  access_token: "[YOUR_ACCESS_TOKEN]",
  environment: "production",
  enabled: true

config :task_bunny,
  failure_backend: [TaskBunnyRollbar]
```

Check [Rollbax](https://hex.pm/packages/rollbax) or
[TaskBunny](https://github.com/shinyscorpion/task_bunny#failure-backends) for
more configuration options.

## Copyright and License

Copyright (c) 2017, SQUARE ENIX LTD.

TaskBunnyRollbar code is licensed under the [MIT License](LICENSE.md).
