class BundlerBashCompletion
  
  TASKS = %w(
    check
    config
    console
    exec
    gem
    help
    init
    install
    list
    open
    outdated
    package
    show
    update
  ).freeze
  
  attr_reader :line

  def initialize(line)
    @line = line.to_s.gsub(/^\s+/, '').freeze
  end
  
  def arguments
    @arguments ||= line.split(/\s+/)
  end
  
  def command
    arguments.first.to_s
  end
  
  def complete
    return tasks if task_completion?
    []
  end
  
  private
  
  def available?
    command == 'bundle' && completion_step > 0
  end
  
  def completion_step
    @completion_step ||= arguments.size - 1 + (line =~ /\s+$/ ? 1 : 0)
  end
  
  def completion_step?(step)
    completion_step == step
  end
  
  def task
    @task ||= arguments[1].to_s
  end
  
  def task_completion?
    available? && completion_step?(1)
  end
  
  def tasks
    TASKS.select { |t| t.start_with?(task) }
  end
  
end