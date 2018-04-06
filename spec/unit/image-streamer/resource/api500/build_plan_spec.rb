require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API500::BuildPlan
RSpec.describe klass do
  include_context 'shared context'
  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API300::BuildPlan
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_i3s_500)
      expect(item['type']).to eq('OeBuildPlanV5')
    end
  end
end
