require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::EnclosureGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#script' do
    it 'can retrieve the script' do
      item = klass.find_by($client_300, name: ENC_GROUP_NAME).first
      script = item.get_script
      expect(script).to be_a(String)
    end

    it 'returns method unavailable for the set_script method' do
      item = klass.find_by($client_300, name: ENC_GROUP_NAME).first
      expect { item.set_script }.to raise_error(/The method #set_script is unavailable for this resource/)
    end
  end
end
