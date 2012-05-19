#!/usr/bin/env ruby
#bundle exec test/create_supervisor.rb

require 'daemonizer'

class MyDaemon < Daemonizer::Daemon


  def before_perform
    @finish_time = Time.at(Time.now.to_i + 60 * 1)
  end

  def perform
    p @finish_time - Time.now
    sleep 1
    stop if Time.now > @finish_time
  end

end


supervisor = Daemonizer::Supervisor.new
daemon = MyDaemon.new

supervisor.add_daemon daemon
supervisor.run