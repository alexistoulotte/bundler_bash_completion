Gem::Specification.new do |s|
  s.name = 'bundler_bash_completion'
  s.version = File.read(File.expand_path(File.dirname(__FILE__) + '/VERSION')).strip
  s.platform = Gem::Platform::RUBY
  s.author = 'Alexis Toulotte'
  s.email = 'al@alweb.org'
  s.homepage = 'https://github.com/alexistoulotte/bundler_bash_completion'
  s.summary = 'Bundler bash completion'
  s.description = 'Provides bash completion for bundle command'

  s.rubyforge_project = 'bundler_bash_completion'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
