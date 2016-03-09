require 'thread'

class RobotDispatcherService

  DEFAULT_SLEEP = 5.0

  attr_accessor :sleep

  def initialize(_options={})
    @sleep = _options.fetch :sleep, DEFAULT_SLEEP
    @mutex = Mutex.new
    @resource = ConditionVariable.new
    @stopping = false
    @thread = nil
  end

  def running?
    !@thread.nil?
  end

  def run
    @mutex.synchronize do
      fail "Already running" if running?

      @thread = Thread.current
      begin
        while !@stopping
          tick
          @resource.wait @mutex, sleep
        end
      ensure
        @thread = nil
        @stopping = false
      end
    end
  end

  def stop
    thread = nil
    @mutex.synchronize do
      @stopping = true
      @resource.signal
      thread = @thread
    end
    thread.join unless thread.nil?
  end

  def tick
    Robot.due_execution.each do |robot|
      next unless robot.try_set_started
      RobotRunnerJob.perform_later robot
    end
  end
end
