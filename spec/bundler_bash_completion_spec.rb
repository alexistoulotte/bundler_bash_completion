require 'spec_helper'

describe BundlerBashCompletion do
  
  def completion(line = nil)
    BundlerBashCompletion.new(line)
  end
  
  describe '#arguments' do

    it 'is given line splitted by whitespaces' do
      completion('bundle exec   rails s').arguments.should == ['bundle', 'exec', 'rails', 's']
    end

  end
  
  describe '#bins' do

    it 'is installed binaries' do
      completion.bins.should include('autospec', 'gem', 'ldiff', 'rake', 'rspec')
      completion.bins.should_not include('rails')
    end
    
  end
  
  describe '#command' do

    it 'is first argument' do
      completion('bundle exec').command.should == 'bundle'
      completion('rake').command.should == 'rake'
    end
    
    it 'is empty string if line is blank' do
      completion(nil).command.should == ''
    end

  end
  
  describe '#complete' do
    
    context 'with "foo"' do

      it 'is an empty array' do
        completion('foo').complete.should == []
      end

    end
    
    context 'with "bundle"' do

      it 'is an empty array' do
        completion('bundle').complete.should == []
      end

    end
    
    context 'with "bundle "' do

      it 'is all tasks' do
        completion('bundle ').complete.should include('check', 'outdated', 'list', 'show')
      end

    end
    
    context 'with "bundle  "' do

      it 'is all tasks' do
        completion('bundle  ').complete.should include('check', 'outdated', 'list', 'show')
      end

    end
    
    context 'with "bundle in"' do

      it 'is "init" & "install" tasks' do
        completion('bundle in').complete.should == ['init', 'install']
      end

    end
    
    context 'with "bundle in "' do

      it 'is an empty array' do
        completion('bundle in ').complete.should == []
      end

    end
    
    context 'with "bundle foo"' do

      it 'is an empty array' do
        completion('bundle foo').complete.should == []
      end

    end
    
    context 'with "bundle foo "' do

      it 'is an empty array' do
        completion('bundle foo ').complete.should == []
      end

    end
    
    context 'with "bundle install "' do

      it 'is "--local", "--path", "--verbose", "--without", etc.' do
        completion('bundle install ').complete.should include('--local', '--path', '--verbose', '--without')
      end

    end
    
    context 'with "bundle install --p"' do

      it 'is "--path"' do
        completion('bundle install --p').complete.should == ['--path']
      end

    end
    
    context 'with "bundle install --path "' do

      it 'is an empty array' do
        completion('bundle install --path ').complete.should == []
      end

    end
    
    context 'with "bundle install --local "' do

      it 'is "--local", "--path", "--without", etc.' do
        completion('bundle install ').complete.should include('--local', '--path', '--without')
      end

    end
    
    context 'with "bundle help in"' do

      it 'is "init" and "install"' do
        completion('bundle help in').complete.should == ['init', 'install']
      end

    end
    
    context 'with "bundle help install "' do

      it 'is an empty array' do
        completion('bundle help install ').complete.should == []
      end

    end
    
    context 'with "bundle show "' do

      it 'is gems and "--verbose", etc.' do
        completion('bundle show ').complete.should include('diff-lcs', 'rake', 'rspec', '--verbose')
      end

    end
    
    context 'with "bundle show rspec "' do

      it 'is "--paths", "--no-color" and "--verbose"' do
        completion('bundle show rspec ').complete.should == ['--no-color', '--paths', '--verbose']
      end

    end
    
    context 'with "bundle update "' do

      it 'is gems and "--verbose", etc.' do
        completion('bundle update ').complete.should include('diff-lcs', 'rake', 'rspec', '--verbose')
      end

    end
    
    context 'with "bundle update rake rspec "' do

      it 'is gems (without rake & rspec) and "--verbose", etc.' do
        completion('bundle update rake rspec ').complete.should include('bundler', 'diff-lcs', 'rspec-core', '--verbose')
        completion('bundle update rake rspec ').complete.should_not include('rake', 'rspec')
      end

    end
    
    context 'with "bundle exec "' do

      it 'is bins' do
        completion('bundle exec ').complete.should include('ldiff', 'rake', 'rspec')
        completion('bundle exec ').complete.should_not include('--verbose')
      end

    end
    
    context 'with "bundle exec rake "' do

      it 'is an empty array' do
        completion('bundle exec rake ').complete.should == []
      end

    end
    
  end
  
  describe '#completion_word' do

    it 'is last word on line' do
      completion('bundle instal').completion_word.should == 'instal'
    end
    
    it 'is an empty string if line ends with a white space' do
      completion('bundle install ').completion_word.should == ''
      completion('bundle install  ').completion_word.should == ''
    end

  end
  
  describe '#gems' do

    it 'is installed gems' do
      completion.gems.should include('bundler', 'rake', 'rspec', 'rspec-core', 'rspec-expectations')
      completion.gems.should_not include('rails')
    end

  end

  describe '#line' do
    
    it 'is line given at initializion' do
      completion('hello').line.should == 'hello'
    end

    it 'is frozen' do
      expect {
        completion('hello').line.gsub!('l', 'w')
      }.to raise_error(/can't modify frozen String/)
    end
    
    it 'is converted to string' do
      completion(:hello).line.should == 'hello'
    end
    
    it 'first whitespaces are removed' do
      completion(' hello').line.should == 'hello'
    end
    
    it 'last whitespaces are preserved' do
      completion('hello ').line.should == 'hello '
    end

  end
  
  describe '#task' do
    
    it 'is an empty string when not ending with a whitespace' do
      completion('bundle install').task.should == ''
    end
    
    it 'is task given by second argument if ending with a whitespace' do
      completion('bundle install ').task.should == 'install'
      completion('bundle foo ').task.should == 'foo'
      completion('bundle help install ').task.should == 'help'
    end
    
  end
    
  describe '#task_options' do

    it 'is correct' do
      completion('bundle install --path').task_options.should == []
      completion('bundle install ').task_options.should == []
      completion('bundle install --path fo').task_options.should == ['--path']
      completion('bundle install --path fo ').task_options.should == ['--path', 'fo']
    end

  end

end
