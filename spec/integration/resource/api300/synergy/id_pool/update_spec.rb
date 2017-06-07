require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::IDPool, integration: true, type: UPDATE do
  include_context 'integration context'

  subject(:item) { described_class.new($client) }
  let(:pool_type) { 'vmac' }

  before :each do
    @response = nil
  end

  describe '#get_pool' do
    it 'gets a pool by type - IPV4' do
      item.get_pool('IPV4')
      expect(item['poolType']).to eq('IPV4')
    end

    it 'gets a pool by type - VMAC' do
      item.get_pool('vmac')
      expect(item['poolType']).to eq('VMAC')
    end

    it 'gets a pool by type - VSN' do
      item.get_pool('VSN')
      expect(item['poolType']).to eq('VSN')
    end

    it 'gets a pool by type - VWWN' do
      item.get_pool('VWWN')
      expect(item['poolType']).to eq('VWWN')
    end
  end

  describe '#update' do
    it 'enabling and disabling a pool' do
      item.get_pool(pool_type)
      item['enabled'] = false
      item.update
      item.get_pool(pool_type)
      expect(item['enabled']).to eq(false)
      item['enabled'] = true
      item.update
      item.get_pool(pool_type)
      expect(item['enabled']).to eq(true)
    end
  end

  describe '#generate_random_range' do
    it 'generating a random range' do
      expect { @response = item.generate_random_range(pool_type) }.to_not raise_error
      expect(@response['startAddress']).to be_truthy
      expect(@response['endAddress']).to be_truthy
    end
  end

  describe '#allocate' do
    it 'allocating an amount IDs' do
      expect { @response = item.allocate_count(pool_type, 5) }.to_not raise_error
      expect(@response['count']).to eq(5)
      expect(@response['idList'].size).to eq(5)
      # Collecting the IDs allocated
      item.collect_ids(pool_type, @response['idList'])
    end

    it 'allocating a list of IDs' do
      vmacs = item.generate_random_range(pool_type)
      expect { @response = item.allocate_id_list(pool_type, vmacs['startAddress'], vmacs['endAddress']) }.to_not raise_error
      expect(@response['count']).to eq(2)
      expect(@response['idList']).to match_array([vmacs['startAddress'], vmacs['endAddress']])
      # Collecting the IDs allocated
      item.collect_ids(pool_type, @response['idList'])
    end
  end

  describe '#check_range_availability' do
    it 'checking the range availability' do
      expect { @response = item.check_range_availability(pool_type, 'A2:32:C3:D0:00:00', 'A2:32:C3:DF:FF:FF') }.to_not raise_error
      expect(@response['idList']).to match_array(['A2:32:C3:D0:00:00', 'A2:32:C3:DF:FF:FF'])
    end
  end

  describe '#validate_id_list' do
    it 'validating a list of IDs' do
      vmacs = item.generate_random_range(pool_type)
      expect { @response = item.validate_id_list(pool_type, vmacs['startAddress'], vmacs['endAddress']) }.to_not raise_error
      expect(@response).to eq(true)
    end
  end

  describe '#collect_ids' do
    it 'collecting IDs' do
      # Allocating IDs to test
      allocated_ids = item.allocate_count(pool_type, 5)
      expect { @response = item.collect_ids(pool_type, allocated_ids['idList']) }.to_not raise_error
      expect(@response['idList']).to match_array(allocated_ids['idList'])
    end
  end
end
