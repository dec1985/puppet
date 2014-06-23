require 'spec_helper'
describe 'highnoon' do

  context 'with defaults for all parameters' do
    it { should contain_class('highnoon') }
  end
end
