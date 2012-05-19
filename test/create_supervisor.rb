#!/usr/bin/env ruby
#bundle exec test/create_supervisor.rb

require 'daemonizer'

class MyDaemon < Daemonizer::Daemon

  def before_perform
    @finish_time = Time.at(Time.now.to_i + rand(1..60))
  end

  def perform
    p @finish_time - Time.now
    sleep 1
    stop if Time.now > @finish_time
  end

end


supervisor = Daemonizer::Supervisor.new

3.times do |n|
  daemon = MyDaemon.new "mydaemon_#{n}"
  supervisor.add_daemon daemon
end

supervisor.run