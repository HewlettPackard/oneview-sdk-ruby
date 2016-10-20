require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#add' do
    it 'can add an enclosure' do
      item = OneviewSDK::API300::Thunderbird::Enclosure.new($client_300, 'hostname' => 'fe80::2:0:9:1%eth2')
      item.set_enclosure_group(OneviewSDK::API300::Thunderbird::EnclosureGroup.new($client_300, 'name' => ENC_GROUP2_NAME))
      item.add
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      item = OneviewSDK::API300::Thunderbird::Enclosure.find_by($client_300, name: ENCL_NAME).first
      expect { item.environmental_configuration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = OneviewSDK::API300::Thunderbird::Enclosure.find_by($client_300, name: ENCL_NAME).first
      expect { item.utilization }.not_to raise_error
    end
  end
end
