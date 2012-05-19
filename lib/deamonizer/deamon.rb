class Deamonizer::Deamon
  TMP_PATH = '/tmp/'
  LOG_PATH = '/tmp/'

  def initialize(name)
    @name = name
    @pidfile = nil
    @pid = 0
  end

  def run(&block)
    create_pidfile
    init_std

    @pid = fork do
      perform
      exit!(1)
    end
    Process.detach(@pid)

  end


  def started?
    file = pidfile('r')
    flock_result = file.flock File::LOCK_EX|File::LOCK_NB
    case flock_result
      when 0; begin
        file.flock File::LOCK_UN
        file.close
        return false
      end
      when false; begin
        file.close
        return true
      end
    end
  end

  def pidfile(method = 'w')
    File.new("#{TMP_PATH}#{@name}.pid", method)
  end

  def create_pidfile
    @pidfile = pidfile
    @pidfile.write Process.pid
    @pidfile.flock File::LOCK_EX
  end

  def init_std
    $stdout = File.new "#{LOG_PATH}#{@name}.log", 'w'
    $stderr = File.new "#{LOG_PATH}#{@name}.error.log", 'w'
  end

  def trap_signals
    Signal.trap "USR1" do
      p Process.pid
    end
  end
end