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
  
  def complete
    []
  end
  
end