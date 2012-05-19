#!/usr/bin/env ruby
require 'daemonizer'

class MyDaemon < Daemonizer::Daemon

  def perform
    while(true)
      p Time.now
      sleep 1
    end
  end

end

MyDaemon.new.run