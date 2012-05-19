#!/usr/bin/env ruby
require 'deamonizer'

class MyDeamon

  include Deamonizer::Deamon

  def perform
    while(true)
      p Time.zone.now
      sleep 1
    end
  end

end

MyDeamon.new.run