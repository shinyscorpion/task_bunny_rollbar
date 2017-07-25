# TaskBunnyRollbar

[![Hex.pm](https://img.shields.io/hexpm/v/task_bunny_rollbar.svg "Hex")](https://hex.pm/packages/task_bunny_rollbar)
[![Build Status](https://travis-ci.org/shinyscorpion/task_bunny_rollbar.svg?branch=master)](https://travis-ci.org/shinyscorpion/task_bunny_rollbar)
[![Inline docs](http://inch-ci.org/github/shinyscorpion/task_bunny_rollbar.svg?branch=master)](http://inch-ci.org/github/shinyscorpion/task_bunny_rollbar)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/shinyscorpion/task_bunny_rollbar.svg)](https://beta.hexfaktor.org/github/shinyscorpion/task_bunny_rollbar)
[![Hex.pm](https://img.shields.io/hexpm/l/task_bunny_rollbar.svg "License")](LICENSE.md)

TaskBunny failure backend for Rollbar.

## Installation

```elixir
def deps do
  [{:task_bunny_rollbar, "~> 0.1.1"}]
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

## Gotcha

#### Report only when the job is rejected

You might not want to report the failures which are going to be retried.
You can do it by writing a thin wrapper in your application.

```elixir
defmodule TaskBunnyRollbarWrapper do
  use TaskBunny.FailureBackend
  alias TaskBunny.JobError

  # reject = true means the job won't be retried.
  def report_job_error(error = %JobError{reject: true}),
    do: TaskBunnyRollbar.report_job_error(error)

  # otherwise ignore.
  def report_job_error(_), do: nil
end
```

Don't forget to set the wrapper module as your failure backend.

```elixir
config :task_bunny, failure_backend: [TaskBunnyRollbarWrapper]
```

## Copyright and License

Copyright (c) 2017, SQUARE ENIX LTD.

TaskBunnyRollbar code is licensed under the [MIT License](LICENSE.md).
