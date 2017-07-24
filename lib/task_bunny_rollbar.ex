defmodule TaskBunnyRollbar do
  @moduledoc """
  A TaskBunny failure backend that reports to Rollbar.
  """
  use TaskBunny.FailureBackend
  alias TaskBunny.JobError

  def report_job_error(error = %JobError{error_type: :exception}) do
    report :error, error.exception, error
  end

  def report_job_error(error = %JobError{error_type: :exit}) do
    report :exit, error.reason, error
  end

  def report_job_error(error = %JobError{error_type: :return_value}) do
    report :exit, :task_bunny_job_return_value_error, error
  end

  def report_job_error(error = %JobError{error_type: :timeout}) do
    report :exit, :task_bunny_job_timeout_error, error
  end

  def report_job_error(error = %JobError{}) do
    report :exit, :task_bunny_job_unknown_type_error, error
  end

  defp report(kind, rollbar_error, error) do
    Rollbax.report(
      kind,
      rollbar_error,
      error.stacktrace || [],
      custom(error),
      occurrence(error)
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
