class Daemonizer::Daemon

  TMP_PATH = '/tmp/'
  LOG_PATH = '/tmp/'
  DETACH = false
  CYCLES = true

  attr_reader :name

  def initialize(_name = nil)
    @name = _name || self.class.to_s.downcase
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

    def started?
      @pid_file.locked?
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
