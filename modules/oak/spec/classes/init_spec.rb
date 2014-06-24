require 'spec_helper'
describe 'oak' do

  context 'with defaults for all parameters' do
    it { should contain_class('oak') }
  end
end
