require 'spec_helper'

RSpec.describe OneviewSDK::API800::C7000::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from API600' do
    expect(described_class).to be < OneviewSDK::API600::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_800, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV5')
    end
  end
end
