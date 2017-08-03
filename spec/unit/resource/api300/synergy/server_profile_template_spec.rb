require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::ServerProfileTemplate' do
    expect(described_class).to be < OneviewSDK::API300::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_300, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV2')
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile template' do
      item = described_class.new(@client_300, uri: '/rest/server-profile-templates/fake')
      expect(@client_300).to receive(:rest_get).with("#{item['uri']}/transformation?queryTest=Test")
        .and_return(FakeResponse.new('it' => 'ServerProfileTemplate'))
      expect(item.get_transformation(@client_300, 'query_test' => 'Test')['it']).to eq('ServerProfileTemplate')
    end
  end
end
