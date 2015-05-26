class Logger

  attr_reader :solver, :path

  def initialize(solver)
    @solver  = solver
    @enabled = false

    initialize_path
    print_state
  end

  def print_penalty(penalty)
    if !@solver.parent_solver.nil?
      @solver.parent_solver.log.print_penalty(penalty)
    end

    if @enabled
      log = File.open(File.join(@path, 'penalties.txt'), 'a')

      [$stdout, log].each do |out|
        out.puts "new penalty (#{@solver.penalties.size})"
        out.puts penalty[:node].to_s
        out.puts "value: #{penalty[:value]}"
        out.puts "-----------------------------------"
      end

      log.close
    end
  end

  def print_state
    if @enabled
      log = File.open(File.join(@path, 'state.txt'), 'a')

      [$stdout, log].each do |out|
        out.puts @solver.class.name
        out.puts "bound: #{@solver.bound}" if defined? @solver.bound
        out.puts "-----------------------------------"
        out.puts @solver.level.to_s
        out.puts "-----------------------------------"
      end

      log.close
    end
  end

  private

  def initialize_path
    if @enabled
      folder_name = "#{folder_prefix}-#{(Time.now.to_f * 1000).to_i}"
      parent_path = @solver.parent_solver.nil? ? 'log' : @solver.parent_solver.log.path
      @path       = File.join(parent_path, folder_name)
      FileUtils.mkdir_p(@path)
    end
  end

  def folder_prefix
    if @solver.class == IdaStarSolver
      'ida'
    else
      "a-#{@solver.bound}"
    end
  end

end
