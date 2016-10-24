require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#patch' do
    it 'replaces the enclosure name (numbers) by Enclosure_1' do
      item = klass.find_by($client_300, {}).first
      expect { item.patch('replace', '/name', ENCL_NAME) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(ENCL_NAME)
    end
  end

  # This will FAIL if the enclosure is monitored
  describe '#configuration' do
    it 'update OneViewSDK_Int_Ethernet_Network name' do
      item = klass.find_by($client_300, name: ENCL_NAME).first
      expect { item.configuration }.not_to raise_error
    end
  end

  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      item = klass.find_by($client_300, name: ENCL_NAME).first
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end
end
