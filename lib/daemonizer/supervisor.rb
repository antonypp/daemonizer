class Daemonizer::Supervisor < Daemonizer::Daemon

  CHECK_AFTER_START_SECONDS = 2

  def initialize(name = nil, options = {})
    super
    @daemons = []
    @dnumber = -1
  end

  def perform
    daemon = @daemons[dnumber_next]

    if Time.now.to_i - daemon[:started_at].to_i > CHECK_AFTER_START_SECONDS
      unless daemon[:daemon].started?
        daemon[:daemon].run
        daemon[:started_at] = Time.now
        p "#{daemon[:started_at]}: Start daemon #{daemon[:daemon].name}"
      end
    end

  end

  def add_daemon(daemon)
    @daemons <<  {
        :daemon => daemon
    }
  end

  private

    def dnumber_next
      @dnumber += 1
      @dnumber = 0 unless @daemons[@dnumber]
      @dnumber
    end

end