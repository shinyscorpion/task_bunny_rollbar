defmodule TaskBunnyRollbar do
  @moduledoc """
  A TaskBunny failure backend that reports to Rollbar.
  """
  use TaskBunny.FailureBackend
  alias TaskBunny.JobError

  def report_job_error(error = %JobError{error_type: :exception}) do
    report_error :error, error.exception, error
  end

  def report_job_error(error = %JobError{error_type: :exit}) do
    report_error :exit, error.reason, error
  end

  def report_job_error(error = %JobError{error_type: :return_value}) do
    "#{error.job}: return value error"
    |> report_message(error)
  end

  def report_job_error(error = %JobError{error_type: :timeout}) do
    "#{error.job}: timeout error"
    |> report_message(error)
  end

  def report_job_error(error = %JobError{}) do
    "#{error.job}: unknown error"
    |> report_message(error)
  end

  defp report_error(kind, rollbar_error, error) do
    Rollbax.report(
      kind,
      rollbar_error,
      error.stacktrace || [],
      custom(error),
      occurrence(error)
    )
  end

  defp report_message(message, error) do
    body = %{
      "message" => %{
        "body" => message,
        "job" => error.job
      }
    }

    Rollbax.report_message(
      :error, inspect(body), custom(error), occurrence(error)
    )
  end

  defp occurrence(error) do
    %{
      "context" => error.job,
      "request" => %{
        "params" => error.payload
      }
    }
  end

  defp custom(error) do
    error
    |> Map.drop([:job, :payload, :__struct__, :exception, :stacktrace, :reason])
    |> Map.merge(%{
      meta: inspect(error.meta),
      return_value: inspect(error.return_value),
      pid: inspect(error.pid)
    })
  end
end
