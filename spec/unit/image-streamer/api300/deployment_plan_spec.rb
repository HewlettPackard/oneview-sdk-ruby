require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::DeploymentPlan
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_i3s_300)
      expect(item['type']).to eq('OEDeploymentPlan')
    end
  end
end
