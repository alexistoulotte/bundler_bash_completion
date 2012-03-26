require 'spec_helper'

describe BundlerBashCompletion do
  
  def completion(line)
    BundlerBashCompletion.new(line)
  end
  
  describe '#arguments' do

    it 'is given line splitted by whitespaces' do
      completion('bundle exec   rails s').arguments.should == ['bundle', 'exec', 'rails', 's']
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

      it 'returns an empty array' do
        completion('bundle foo').complete.should == []
      end

    end
    
    context 'with "bundle foo "' do

      it 'returns an empty array' do
        completion('bundle foo ').complete.should == []
      end

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

end
