require "daemonizer/version"

module Daemonizer
  autoload "Daemon", "daemonizer/daemon"
  autoload "Supervisor", "daemonizer/supervisor"
  autoload "PidFile", "daemonizer/pid_file"

end
