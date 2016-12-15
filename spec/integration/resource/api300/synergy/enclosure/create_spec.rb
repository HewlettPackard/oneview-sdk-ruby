require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#add' do
    it 'can add an enclosure' do
      item = klass.new($client_300_synergy, hostname: ENCL_HOSTNAME, name: ENCL_NAME)
      encl1 = item.add[0]
      expect(encl1).to be
      expect(encl1['uri']).not_to be_empty
      expect(encl1['name']).to eq("#{ENCL_NAME}3")
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      item = klass.find_by($client_300_synergy, {}).first
      expect { item.environmental_configuration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = klass.find_by($client_300_synergy, {}).first
      expect { item.utilization }.not_to raise_error
    end
  end
end
