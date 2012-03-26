require 'spec_helper'

describe BundlerBashCompletion do
  
  describe '#complete' do

    it 'should have specs'

  end

  describe '#line' do
    
    it 'is line given at initializion' do
      BundlerBashCompletion.new('hello').line.should == 'hello'
    end

    it 'is frozen' do
      expect {
        BundlerBashCompletion.new('hello').line.gsub!('l', 'w')
      }.to raise_error(/can't modify frozen String/)
    end
    
    it 'is converted to string' do
      BundlerBashCompletion.new(:hello).line.should == 'hello'
    end
    
    it 'first whitespaces are removed' do
      BundlerBashCompletion.new(' hello').line.should == 'hello'
    end
    
    it 'last whitespaces are preserved' do
      BundlerBashCompletion.new('hello ').line.should == 'hello '
    end

  end

end
