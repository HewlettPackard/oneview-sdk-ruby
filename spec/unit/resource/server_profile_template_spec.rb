require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfileTemplate do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the type correctly' do
      template = OneviewSDK::ServerProfileTemplate.new(@client)
      expect(template[:type]).to eq('ServerProfileTemplateV1')
    end
  end

  describe '#new_profile' do
    it 'returns a profile' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(name: 'NewProfile')
      expect(@client).to receive(:rest_get).with('/rest/server-profile-templates/fake/new-profile')
      template = OneviewSDK::ServerProfileTemplate.new(@client, uri: '/rest/server-profile-templates/fake')
      profile = template.new_profile
      expect(profile.class).to eq(OneviewSDK::ServerProfile)
    end

    it 'can set the name of a new profile' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(name: 'NewProfile')
      template = OneviewSDK::ServerProfileTemplate.new(@client, uri: '/rest/server-profile-templates/fake')
      profile = template.new_profile('NewName')
      expect(profile[:name]).to eq('NewName')
    end
  end
end
