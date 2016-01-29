require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure, integration: true do
  include_context 'integration context'

  let(:enclosure_data) do
    {
      enclosureGroupUri: '/rest/enclosure-groups/5e1c6504-6cbd-4867-abb3-4aab095c34e8',
      hostname: '172.18.1.11',
      username: 'dcs',
      password: 'dcs',
      licensingIntent: 'OneView'
    }
  end

  describe '#create' do
    it 'can create resources' do
      puts enclosure_data
      item = OneviewSDK::Enclosure.new(@client, enclosure_data)
      item.create
      expect(item[:uri]).not_to be_empty
    end
  end

  describe '#save' do
    it 'Changes name' do
      item = OneviewSDK::Enclosure.find_by(@client, name: 'Encl1').first
      item[:name] = 'Enclosure_QA'
      item.save
      expect(item[:name]).to eq('Enclosure_QA')
    end
  end

  describe '#configuration' do
    it 'update OneViewSDK_Int_Ethernet_Network name' do
      expect { OneviewSDK::Enclosure.find_by(@client, name: 'Enclosure_QA').first.configuration }.not_to raise_error
    end
  end


  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      expect { OneviewSDK::Enclosure.find_by(@client, name: 'Enclosure_QA').first.refreshState('RefreshPending') }.not_to raise_error
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      expect { OneviewSDK::Enclosure.find_by(@client, name: 'Enclosure_QA').first.environmentalConfiguration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      expect { OneviewSDK::Enclosure.find_by(@client, name: 'Enclosure_QA').first.utilization }.not_to raise_error
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::Enclosure.find_by(@client, name: 'Enclosure_QA').first
      item[:name] = 'Encl1'
      item.save
      expect { item.delete }.not_to raise_error
    end
  end
end
