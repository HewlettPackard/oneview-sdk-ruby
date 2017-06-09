require 'spec_helper'

RSpec.describe OneviewSDK::IDPool do
  include_context 'shared context'

  subject(:item) { described_class.new(@client_200) }
  let(:vmac1) { 'A2:32:C3:D0:00:00' }
  let(:vmac2) { 'A2:32:C3:DF:FF:FF' }
  let(:id_list) { [vmac1, vmac2] }
  let(:pool_type) { 'vmac' }

  describe '#create' do
    it 'is unavailable' do
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#get_pool' do
    it 'getting a pool' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_get).with('/rest/id-pools/vmac').and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(name: 'AnyPool')
      item.get_pool(pool_type)
      expect(item['name']).to eq('AnyPool')
    end
  end

  describe '#allocate_id_list' do
    it 'allocating' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_put).with('/rest/id-pools/vmac/allocator', 'body' => { idList: id_list }).and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(id_list)
      response = item.allocate_id_list(pool_type, id_list)
      expect(response).to match_array(id_list)
    end
  end

  describe '#allocate_count' do
    it 'allocating' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_put).with('/rest/id-pools/vmac/allocator', 'body' => { count: 2 }).and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(id_list)
      response = item.allocate_count(pool_type, 2)
      expect(response).to match_array(id_list)
    end
  end

  describe '#check_range_availability' do
    it 'checking a range' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_get)
        .with("/rest/id-pools/vmac/checkrangeavailability?idList=#{vmac1}&idList=#{vmac2}").and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(id_list)
      response = item.check_range_availability(pool_type, id_list)
      expect(response).to match_array(id_list)
    end
  end

  describe '#collect_ids' do
    it 'collecting ids' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_put)
        .with('/rest/id-pools/vmac/collector', 'body' => { 'idList' => id_list }).and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(id_list)
      response = item.collect_ids(pool_type, id_list)
      expect(response).to match_array(id_list)
    end
  end

  describe '#generate_random_range' do
    it 'generating a random range' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_get).with('/rest/id-pools/vmac/generate').and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return('startAddress' => vmac1, 'endAddress' => vmac2)
      response = item.generate_random_range(pool_type)
      expect(response['startAddress']).to eq(vmac1)
      expect(response['endAddress']).to eq(vmac2)
    end
  end

  describe '#validate_id_list' do
    it 'validating a list of IDs' do
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_put)
        .with('/rest/id-pools/vmac/validate', 'body' => { 'idList' => id_list }).and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return('valid' => true)
      expect(item.validate_id_list(pool_type, id_list)).to eq(true)
    end
  end
end
