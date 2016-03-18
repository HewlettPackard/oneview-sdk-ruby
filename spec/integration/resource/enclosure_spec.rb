require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure, integration: true do
  include_context 'integration context'
=begin
  let(:resource_name) { 'Encl1' }
  let(:updated_resource_name) { 'Encl1_UPDATED' }
  let(:enclosure_options) do
    {
      'hostname' => '172.18.1.11',
      'username' => 'dcs',
      'password' => 'dcs',
      'licensingIntent' => 'OneView'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::Enclosure.new(@client, enclosure_options)
      item.set_enclosure_group(OneviewSDK::EnclosureGroup.new(@client, 'name' => 'EnclosureGroup_2'))
      item.create
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#save' do
    it 'Changes name' do
      item = OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first
      item['name'] = updated_resource_name
      item.save
      expect(item['name']).to eq(updated_resource_name)
      item['name'] = resource_name
      item.save
      expect(item['name']).to eq(resource_name)
    end
  end

  describe '#configuration' do
    it 'update OneViewSDK_Int_Ethernet_Network name' do
      expect { OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first.configuration }.not_to raise_error
    end
  end


  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      expect { OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first.refreshState('RefreshPending') }.not_to raise_error
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the script' do
      expect { OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first.environmentalConfiguration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      expect { OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first.utilization }.not_to raise_error
    end
  end

  # describe '#delete' do
  #   it 'deletes the resource' do
  #     item = OneviewSDK::Enclosure.find_by(@client, 'name' => resource_name).first
  #     item['name'] = 'Encl1'
  #     item.save
  #     expect { item.delete }.not_to raise_error
  #   end
  # end
=end
end
