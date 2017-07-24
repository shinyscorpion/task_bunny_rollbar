use Mix.Config

# If you want to try this library with your Rollbar account
# unncomment the below and set your access token.
#
# config :rollbax,
#   access_token: "[YOUR_ACCESS_TOKEN]",
#   environment: "dev",
#   enabled: true
#
# config :task_bunny,
#   failure_backend: [TaskBunnyRollbar],
#   hosts: [
#     default: [connect_options: []]
#   ],
#   queue: [
#     namespace: "task_bunny.rollbar.",
#     queues: [
#       [name: "normal", jobs: :default]
#     ]
#   ]

import_config "#{Mix.env}.exs"
