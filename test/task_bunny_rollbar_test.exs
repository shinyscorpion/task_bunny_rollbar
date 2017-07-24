defmodule TaskBunnyRollbarTest do
  use ExUnit.Case
  alias TaskBunny.JobError
  alias TaskBunnyRollbar.TestJob
  import TaskBunnyRollbar
  import ExUnit.CaptureLog

  @job TestJob
  @payload %{"test" => true}

  defp wait_for_rollbax do
    # meh
    :timer.sleep(50)
  end

  describe "report_job_error/1" do
    test "handle an exception" do
      ex =
        try do
          raise "Hello"
        rescue
          e in RuntimeError -> e
        end
      error = JobError.handle_exception(@job, @payload, ex)

      assert capture_log(fn ->
        report_job_error(error)
        wait_for_rollbax()
      end) =~ ~r/RuntimeError/
    end

    test "handle the exit signal" do
      reason =
        try do
          exit(:test)
        catch
          _, reason -> reason
        end
      error = JobError.handle_exit(@job, @payload, reason)

      assert capture_log(fn ->
        report_job_error(error)
        wait_for_rollbax()
      end) =~ ~r/exit/
    end

    test "handle timeout error" do
      error = JobError.handle_timeout(@job, @payload)

      assert capture_log(fn ->
        report_job_error(error)
        wait_for_rollbax()
      end) =~ ~r/timeout/
    end

    test "handle the invlid return error" do
      error = JobError.handle_return_value(@job, @payload, {:error, :error_detail})

      assert capture_log(fn ->
        report_job_error(error)
        wait_for_rollbax()
      end) =~ ~r/error_detail/
    end
  end
end
