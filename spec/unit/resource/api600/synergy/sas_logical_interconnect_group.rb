require 'spec_helper'
RSpec.describe OneviewSDK::API600::Synergy::SASLogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::SASLogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::SASLogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = described_class.new(@client_600)
      expect(item[:type]).to eq('sas-logical-interconnect-groupV2')
    end
  end
end
