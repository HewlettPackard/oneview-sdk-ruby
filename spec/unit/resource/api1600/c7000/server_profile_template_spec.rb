require 'spec_helper'

RSpec.describe OneviewSDK::API1600::C7000::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from API1200' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_1600, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV8')
    end
  end
end
