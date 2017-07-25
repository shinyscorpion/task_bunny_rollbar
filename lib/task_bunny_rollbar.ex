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
    # Rollbax doesn't do a good job to report non exception.
    # Use private module to report.
    body = %{
      "message" => %{
        "body" => message,
        "job" => error.job
      }
    }

    Rollbax.Client.emit(
      :error, unix_time(), body,
      custom(error), occurrence(error)
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

  defp unix_time() do
    {mgsec, sec, _usec} = :os.timestamp()
    mgsec * 1_000_000 + sec
  end
end
