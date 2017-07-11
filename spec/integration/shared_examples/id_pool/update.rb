# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'IDPoolUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.new(current_client) }
  let(:pool_type) { 'vmac' }

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
      response = item.generate_random_range(pool_type)
      expect(response['startAddress']).to be_truthy
      expect(response['endAddress']).to be_truthy
    end
  end

  describe '#allocate' do
    it 'allocating an amount IDs' do
      response = item.allocate_count(pool_type, 5)
      expect(response['count']).to eq(5)
      expect(response['idList'].size).to eq(5)
      # Collecting the IDs allocated
      item.collect_ids(pool_type, response['idList'])
    end

    it 'allocating a list of IDs' do
      vmacs = item.generate_random_range(pool_type)
      response = item.allocate_id_list(pool_type, vmacs['startAddress'], vmacs['endAddress'])
      expect(response['count']).to eq(2)
      expect(response['idList']).to match_array([vmacs['startAddress'], vmacs['endAddress']])
      # Collecting the IDs allocated
      item.collect_ids(pool_type, response['idList'])
    end
  end

  describe '#check_range_availability' do
    it 'checking the range availability passing an empty list' do
      response = item.check_range_availability(pool_type, [])
      expect(response).to be_empty
    end

    it 'checking the range availability' do
      allocated_ids = item.allocate_count(pool_type, 2)
      response = item.check_range_availability(pool_type, allocated_ids['idList'])
      expect(response['idList']).to match_array(allocated_ids['idList'])
      # Collecting the IDs allocated
      item.collect_ids(pool_type, allocated_ids['idList'])
    end
  end

  describe '#validate_id_list' do
    it 'validating passing an empty list' do
      response = item.check_range_availability(pool_type, [])
      expect(response).to be_empty
    end

    it 'validating a list of IDs' do
      vmacs = item.generate_random_range(pool_type)
      response = item.validate_id_list(pool_type, vmacs['startAddress'], vmacs['endAddress'])
      expect(response).to eq(true)
    end
  end

  describe '#collect_ids' do
    it 'raises an exception when passing an empty list' do
      expect { item.collect_ids(pool_type, []) }.to raise_error(/The list of IDs informed is empty/)
    end

    it 'collecting IDs' do
      # Allocating IDs to test
      allocated_ids = item.allocate_count(pool_type, 5)
      response = item.collect_ids(pool_type, allocated_ids['idList'])
      expect(response['idList']).to match_array(allocated_ids['idList'])
    end
  end
end
