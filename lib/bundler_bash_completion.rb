require 'rubygems'

class BundlerBashCompletion

  TASKS = {
    'check' => {
      '--dry-run' => :continue,
      '--gemfile' => :block,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--path' => :block,
      '--retry' => :block,
      '--verbose' => :continue,
    },
    'clean' => {
      '--dry-run' => :continue,
      '--force' => :continue,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
    },
    'config' => {},
    'console' => {
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
    },
    'exec' => {
      bin: :continue,
    },
    'gem' => {
      '--bin' => :block,
    },
    'help' => {
      task: :continue,
    },
    'init' => {
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
    },
    'install' => {
      '--binstubs' => :continue,
      '--deployment' => :continue,
      '--gemfile' => :block,
      '--local' => :continue,
      '--no-cache' => :continue,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--path' => :block,
      '--retry' => :block,
      '--shebang' => :block,
      '--standalone' => :block,
      '--system' => :continue,
      '--trust-policy' => :block,
      '--verbose' => :continue,
      '--with' => :block,
      '--without' => :block,
    },
    'list' => {
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--paths' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
      :gem => :continue,
    },
    'lock' => {
      '--full-index' => :continue,
      '--local' => :continue,
      '--lockfile' => :block,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--print' => :continue,
      '--retry' => :block,
      '--update' => :continue,
      '--verbose' => :continue,
    },
    'open' => {
      gem: :continue,
    },
    'outdated' => {
      '--local' => :continue,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--pre' => :continue,
      '--retry' => :block,
      '--source' => :block,
      '--verbose' => :continue,
      :gem => :continue,
    },
    'package' => {},
    'platform' => {
      '--ruby' => :continue,
    },
    'show' => {
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-outdated' => :continue,
      '--no-paths' => :continue,
      '--no-verbose' => :continue,
      '--outdated' => :continue,
      '--paths' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
      :gem => :continue,
    },
    'update' => {
      '--bundler' => :block,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-verbose' => :continue,
      '--quiet' => :continue,
      '--retry' => :block,
      '--source' => :block,
      '--verbose' => :continue,
      :gems => :continue,
    },
    'viz' => {
      '--file' => :block,
      '--format' => :block,
      '--no-color' => :continue,
      '--no-no-color' => :continue,
      '--no-requirements' => :continue,
      '--no-verbose' => :continue,
      '--no-version' => :continue,
      '--requirements' => :continue,
      '--retry' => :block,
      '--verbose' => :continue,
      '--version' => :continue,
      '--without' => :block,
    },
  }.freeze

  CONFIG_PATH = '.bundle/config'.freeze

  attr_reader :line

  def initialize(line)
    @line = line.to_s.gsub(/^\s+/, '').freeze
  end

  def arguments
    @arguments ||= line.split(/\s+/)
  end

  def bins
    @bins ||= begin
      gem_paths.map { |path| Dir.glob("#{path}/{bin,exe}/*") }.tap do |paths|
        paths.flatten!
        paths.select! { |path| File.executable?(path) }
        paths.map! { |path| File.basename(path) }
        paths.push('gem', 'ruby')
        paths.sort!
        paths.uniq!
      end
    end
  end

  def command
    arguments.first.to_s
  end

  def completion_word
    @completion_word ||= line =~ /\s+$/ ? '' : arguments.last
  end

  def complete
    return task_options_completion if task_options_completion?
    return tasks_completion if tasks_completion?
    []
  end

  def gems
    @gems ||= begin
      File.readlines("#{Dir.pwd}/Gemfile.lock").grep(/\(.+\)/).tap do |lines|
        lines.each do |line|
          line.gsub!(/\(.+/, '')
          line.gsub!(/\s+/, '')
          line.strip!
        end
      end.tap do |gems|
        gems.push('bundler')
        gems.sort!
        gems.uniq!
      end
    rescue
      []
    end
  end

  def task
    @task ||= completion_step > 1 ? arguments[1].to_s : ''
  end

  def task_options
    @task_options ||= completion_step > 2 ? arguments[2..(completion_step - 1)] : []
  end

  private

  def bundle_command?
    command == 'bundle'
  end

  def bundle_path
    @bundle_path ||= begin
      if File.exist?(CONFIG_PATH)
        require 'yaml'
        path = YAML.load_file(CONFIG_PATH)['BUNDLE_PATH']
        path && File.expand_path(path)
      end
    rescue
      nil
    end
  end

  def completion_step
    @completion_step ||= arguments.size - (completion_word.empty? ? 0 : 1)
  end

  def gem_paths
    @gem_paths ||= begin
      paths = Gem.path.map do |path|
        Dir.glob("#{path}/gems/*")
      end
      paths << Dir.glob("#{bundle_path}/ruby/*/gems/*")
      paths.flatten!
      paths.uniq!
      paths
    end
  end

  def tasks_completion
    TASKS.keys.select { |t| t.start_with?(completion_word) }
  end

  def tasks_completion?
    bundle_command? && completion_step == 1
  end

  def task_options_completion
    options = TASKS[task] || {}
    return [] if options[task_options.last] == :block
    completion = options.keys.map do |key|
      case key
      when :task
        (task_options & TASKS.keys).empty? ? TASKS.keys : nil
      when :gem
        task_options.empty? ? gems : nil
      when :gems
        gems - task_options
      when :bin
        task_options.empty? ? bins : nil
      else
        key
      end
    end
    completion.flatten!
    completion.compact!
    completion.select { |c| c.start_with?(completion_word) }
  end

  def task_options_completion?
    bundle_command? && completion_step > 1 && TASKS.key?(task)
  end

end
