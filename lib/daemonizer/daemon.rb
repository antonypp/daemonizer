class Daemonizer::Daemon

  LOG_PATH = '/tmp/'
  DETACH = true
  CYCLES = true

  attr_reader :name, :pid

  def initialize(_name = nil, options = {})
    @name = _name || self.class.to_s.downcase.gsub('::','_')
    @pid_file = Daemonizer::PidFile.new(@name)
    @pid = 0
  end

  def run(&block)
    exit!(1) if started?
    @pid = fork do
      @pid = Process.pid

      create_pid_file
      init_std

      performed

      finalize
    end
    Process.detach(@pid) if DETACH
  end

  def before_perform
  # callback before perform
  end

  def stop
    finalize
  end

  def started?
    @pid_file.locked?
  end

  private

    def performed
      before_perform
      while(CYCLES)
        trap_signals
        perform
      end
    end

    def finalize
      delete_pid_file
      exit!(1)
    end



    def create_pid_file
      @pid_file.write_pid @pid
      @pid_file.lock
    end

    def delete_pid_file
      @pid_file.delete
    end

    def init_std
      $stdout = File.new "#{LOG_PATH}#{@name}.log", 'w'
      $stderr = File.new "#{LOG_PATH}#{@name}.error.log", 'w'
    end

    def trap_signals
      Signal.trap "QUIT" do
        p 'Daemon QUIT'
        finalize
      end
    end

end
