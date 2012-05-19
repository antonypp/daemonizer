#!/usr/bin/env ruby
require 'daemonizer'

class MyDaemon <

  include Daemonizer::Daemon

  def perform
    while(true)
      p Time.now
      sleep 1
    end
  end

end

MyDaemon.new.run