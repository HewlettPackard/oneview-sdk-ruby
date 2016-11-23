require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalEnclosure
extra_klass_1 = OneviewSDK::API300::Thunderbird::EnclosureGroup
extra_klass_2 = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :each do
    @enclosure_group = extra_klass_1.find_by($client_300_thunderbird, name: ENC_GROUP2_NAME).first
    @enclosure1 = extra_klass_2.find_by($client_300_thunderbird, name: ENCL2_NAME).first
    @enclosure2 = extra_klass_2.find_by($client_300_thunderbird, name: ENCL3_NAME).first
    @enclosure3 = extra_klass_2.find_by($client_300_thunderbird, name: ENCL4_NAME).first
  end

  describe '#create' do
    it 'create a logical enclosure' do
      item = klass.new($client_300_thunderbird, name: LOG_ENCL1_NAME, forceInstallFirmware: false, firmwareBaselineUri: nil)
      item.set_enclosure_group(@enclosure_group)
      item.set_enclosures([@enclosure1, @enclosure2, @enclosure3])
      expect { item.create }.to_not raise_error
      result = klass.find_by($client_300_thunderbird, name: LOG_ENCL1_NAME).first
      expect(result['uri']).to be_truthy
      expect(result['enclosureGroupUri']).to eq(item['enclosureGroupUri'])
      expect(result['enclosureUris']).to eq(item['enclosureUris'])
      expect(result['enclosures'].size).to eq(3)
      expect(result['enclosures'].key?(item['enclosureUris'].first)).to be true
    end
  end
end
