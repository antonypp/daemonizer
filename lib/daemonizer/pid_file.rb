class Daemonizer::PidFile

  DEFAULT_BASE_PATH = '/tmp/'
  attr_reader :base_path

  def initialize(name, b_p = nil)
    @base_path = b_p || DEFAULT_BASE_PATH
    @name = name
    @file = nil
  end

  def locked?
    return false unless File.exist?(path)
    begin
      pfile = get_file('r')
    rescue Errno::ENOENT
      return false
    end

    flock_result = pfile.flock File::LOCK_EX|File::LOCK_NB
    result = flock_result != 0

    pfile.flock File::LOCK_UN unless result
    pfile.close

    result
  end

  def delete
    File.delete(file).close
  end

  def write_pid(pid)
    file.write(pid)
  end

  def lock
    file.flock File::LOCK_EX
  end

  private

    def get_file(method = 'w')
      File.new(path, method)
    end

    def file
      @file ||= get_file
    end

    def path
      "#{base_path}#{@name}.pid"
    end

end