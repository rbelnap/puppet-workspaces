require 'spec_helper'
describe 'workspaces' do
  context 'with default values for all parameters' do
    it { should contain_class('workspaces') }
  end
end
