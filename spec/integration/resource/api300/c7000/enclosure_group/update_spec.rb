require 'spec_helper'

klass = OneviewSDK::API300::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#script' do
    it 'can retrieve the script' do
      item = klass.find_by($client_300, name: ENC_GROUP_NAME).first
      script = item.get_script
      expect(script).to be_a(String)
    end

    it 'can set the script' do
      item = klass.find_by($client_300, name: ENC_GROUP_NAME).first
      item.set_script('#TEST COMMAND')
      expect(item.get_script.tr('"', '')).to eq('#TEST COMMAND')
    end
  end
end
