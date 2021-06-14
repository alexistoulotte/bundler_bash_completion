Gem::Specification.new do |s|
  s.name = 'bundler_bash_completion'
  s.version = File.read("#{File.dirname(__FILE__)}/VERSION").strip
  s.platform = Gem::Platform::RUBY
  s.author = 'Alexis Toulotte'
  s.email = 'al@alweb.org'
  s.homepage = 'https://github.com/alexistoulotte/bundler_bash_completion'
  s.summary = 'Bundler bash completion'
  s.description = 'Provides bash completion for bundle command'
  s.license = 'MIT'

  s.files = `git ls-files | grep -vE '^(spec/|test/|\\.|Gemfile|Rakefile)'`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency 'byebug', '>= 9.0.0', '< 12.0.0'
  s.add_development_dependency 'rake', '>= 12.0.0', '< 14.0.0'
  s.add_development_dependency 'rspec', '>= 3.5.0', '< 4.0.0'
end
