require 'spec_helper'

describe BundlerBashCompletion do

  def completion(line = nil)
    BundlerBashCompletion.new(line)
  end

  describe '#arguments' do

    subject { completion('bundle exec   rails s').arguments }

    it { should eq(['bundle', 'exec', 'rails', 's']) }

  end

  describe '#bins' do

    subject { completion.bins }

    it { should include('gem', 'ldiff', 'rake', 'rspec') }
    it { should_not include('rails') }
    it { should include('ruby') }

  end

  describe '#command' do

    it 'is first argument' do
      expect(completion('bundle exec').command).to eq('bundle')
      expect(completion('rake').command).to eq('rake')
    end

    it 'is empty string if line is blank' do
      expect(completion(nil).command).to eq('')
    end

  end

  describe '#complete' do

    context 'with "foo"' do

      subject { completion('foo').complete }

      it { should eq([]) }

    end

    context 'with "bundle"' do

      subject { completion('bundle').complete }

      it { should eq([]) }

    end

    context 'with "bundle "' do

      subject { completion('bundle ').complete }

      it { should include('check', 'outdated', 'list', 'show') }

    end

    context 'with "bundle  "' do

      subject { completion('bundle  ').complete }

      it { should include('check', 'outdated', 'list', 'show') }

    end

    context 'with "bundle in"' do

      subject { completion('bundle in').complete }

      it { should eq(['init', 'install']) }

    end

    context 'with "bundle in "' do

      subject { completion('bundle in ').complete }

      it { should eq([]) }

    end

    context 'with "bundle foo"' do

      subject { completion('bundle foo').complete }

      it { should eq([]) }

    end

    context 'with "bundle foo "' do

      subject { completion('bundle foo ').complete }

      it { should eq([]) }

    end

    context 'with "bundle install "' do

      subject { completion('bundle install ').complete }

      it { should include('--local', '--path', '--verbose', '--without') }

    end

    context 'with "bundle install --p"' do

      subject { completion('bundle install --p').complete }

      it { should eq(['--path'])  }

    end

    context 'with "bundle install --path "' do

      subject { completion('bundle install --path ').complete }

      it { should eq([]) }

    end

    context 'with "bundle install --local "' do

      subject { completion('bundle install ').complete }

      it { should include('--local', '--path', '--without') }

    end

    context 'with "bundle help in"' do

      subject { completion('bundle help in').complete }

      it { should eq(['init', 'install']) }

    end

    context 'with "bundle help install "' do

      subject { completion('bundle help install ').complete }

      it { should eq([])  }

    end

    context 'with "bundle lock "' do

      subject { completion('bundle lock ').complete }

      it { should include('--update', '--verbose') }

    end

    context 'with "bundle show "' do

      subject { completion('bundle show ').complete }

      it { should include('diff-lcs', 'rake', 'rspec', '--verbose') }

    end

    context 'with "bundle show rspec "' do

      subject { completion('bundle show rspec ').complete }

      it { should eq(['--no-color', '--paths', '--verbose']) }

    end

    context 'with "bundle show foo "' do

      subject { completion('bundle show foo ').complete }

      it { should eq(['--no-color', '--paths', '--verbose']) }

    end

    context 'with "bundle update "' do

      subject { completion('bundle update ').complete }

      it { should include('diff-lcs', 'rake', 'rspec', '--verbose') }

    end

    context 'with "bundle update rake rspec "' do

      subject { completion('bundle update rake rspec ').complete }

      it { should include('bundler', 'diff-lcs', 'rspec-core', '--verbose') }
      it { should_not include('rake', 'rspec') }

    end

    context 'with "bundle exec "' do

      subject { completion('bundle exec ').complete }

      it { should include('ldiff', 'rake', 'rspec') }
      it { should_not include('--verbose') }
      it { should include('gem', 'ruby') }

    end

    context 'with "bundle exec foo "' do

      subject { completion('bundle exec foo ').complete }

      it { should eq([]) }

    end

    context 'with "bundle exec rake "' do

      subject { completion('bundle exec rake ').complete }

      it { should eq([]) }

    end

  end

  describe '#completion_word' do

    it 'is last word on line' do
      expect(completion('bundle instal').completion_word).to eq('instal')
    end

    it 'is an empty string if line ends with a white space' do
      expect(completion('bundle install ').completion_word).to eq('')
      expect(completion('bundle install  ').completion_word).to eq('')
    end

  end

  describe '#gems' do

    subject { completion.gems }

    it { should include('bundler', 'rake', 'rspec', 'rspec-core', 'rspec-expectations') }
    it { should_not include('rails') }

  end

  describe '#line' do

    it 'is line given at initializion' do
      expect(completion('hello').line).to eq('hello')
    end

    it 'is frozen' do
      expect {
        completion('hello').line.gsub!('l', 'w')
      }.to raise_error(/can't modify frozen String/)
    end

    it 'is converted to string' do
      expect(completion(:hello).line).to eq('hello')
    end

    it 'first whitespaces are removed' do
      expect(completion(' hello').line).to eq('hello')
    end

    it 'last whitespaces are preserved' do
      expect(completion('hello ').line).to eq('hello ')
    end

  end

  describe '#task' do

    it 'is an empty string when not ending with a whitespace' do
      expect(completion('bundle install').task).to eq('')
    end

    it 'is task given by second argument if ending with a whitespace' do
      expect(completion('bundle install ').task).to eq('install')
      expect(completion('bundle foo ').task).to eq('foo')
      expect(completion('bundle help install ').task).to eq('help')
    end

  end

  describe '#task_options' do

    it 'is correct' do
      expect(completion('bundle install --path').task_options).to eq([])
      expect(completion('bundle install ').task_options).to eq([])
      expect(completion('bundle install --path fo').task_options).to eq(['--path'])
      expect(completion('bundle install --path fo ').task_options).to eq(['--path', 'fo'])
    end

  end

end
