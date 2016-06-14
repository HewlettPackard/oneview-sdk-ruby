require 'spec_helper'

RSpec.describe OneviewSDK::Datacenter, integration: true, type: CREATE, sequence: 4 do
  include_context 'integration context'

  describe '#create' do
    it 'Add datacenter with default values' do
      options = {
        name: DATACENTER1_NAME,
        width: 5000,
        depth: 5000
      }
      item = OneviewSDK::Datacenter.new($client, options)
      item.create
      expect(item['uri']).not_to be_empty
    end

    it 'Add datacenter with specified properties' do
      options = {
        name: DATACENTER2_NAME,
        width: 5000,
        depth: 5000,
        coolingCapacity: 5,
        costPerKilowattHour: 0.10,
        currency: 'USD',
        deratingType: 'NaJp',
        deratingPercentage: 20.0,
        defaultPowerLineVoltage: 220,
        coolingMultiplier: 1.5
      }
      item = OneviewSDK::Datacenter.new($client, options)
      item.create
      expect(item['uri']).not_to be_empty
      options.each do |key, value|
        expect(item[key.to_s]).to eq(value)
      end
    end

    it 'Add datacenter including an existing rack' do
      options = {
        name: DATACENTER3_NAME,
        width: 5000,
        depth: 5000
      }
      item = OneviewSDK::Datacenter.new($client, options)
      item.create
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#get_visual_content' do
    it 'Gets utilization data' do
      item = OneviewSDK::Datacenter.find_by($client, name: DATACENTER1_NAME).first
      expect { item.get_visual_content }.not_to raise_error
    end
  end
end
