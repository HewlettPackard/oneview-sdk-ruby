require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#script' do
    it 'can retrieve the script' do
      item = OneviewSDK::EnclosureGroup.find_by($client, name: ENC_GROUP_NAME).first
      script = item.script
      expect(script).to be_a(String)
    end

    it 'can set the script' do
      item = OneviewSDK::EnclosureGroup.find_by($client, name: ENC_GROUP_NAME).first
      item.set_script('#TEST COMMAND')
      expect(item.script.tr('"', '')).to eq('#TEST COMMAND')
    end
  end
end
