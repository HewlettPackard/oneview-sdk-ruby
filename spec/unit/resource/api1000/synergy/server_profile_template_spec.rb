require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::ServerProfileTemplate' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_1000, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV6')
    end
  end
end