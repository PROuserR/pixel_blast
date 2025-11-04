# frozen_string_literal: true

# Timer class for frame‑rate‑independent timer pattern
# — no threads, no sleep, just pure update‑loop logic.
class Timer
  attr_reader :remaining

  def initialize(seconds, &on_finish)
    @duration   = seconds.to_f
    @remaining  = @duration
    @on_finish  = on_finish
    @running    = false
  end

  def start
    @remaining = @duration
    @running   = true
  end

  def tick(time)
    return unless @running

    @remaining -= time
    return unless @remaining <= 0

    @remaining = 0
    @running   = false
    @on_finish&.call
  end

  def add_time(seconds)
    @remaining += seconds.to_f
  end

  def running?
    @running
  end
end
