require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::StoragePool.new(@client)
      expect(profile[:type]).to eq('StoragePoolV2')
    end
  end

  describe '#set_storage_system' do
    it 'sets the storageSystemUri value' do
      item = OneviewSDK::StoragePool.new(@client)
      item.set_storage_system(OneviewSDK::StorageSystem.new(@client, uri: '/rest/fake'))
      expect(item['storageSystemUri']).to eq('/rest/fake')
    end
  end

  describe '#validate' do
    context 'refreshState' do
      it 'allows valid refresh states' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        described_class::VALID_REFRESH_STATES.each do |state|
          storage_pool[:refreshState] = state
          expect(storage_pool[:refreshState]).to eq(state)
        end
      end

      it 'does not allow invalid refresh states' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        expect { storage_pool[:refreshState] = 'Complete' }.to raise_error.with_message(/Invalid refresh state/)
      end
    end

    context 'status' do
      it 'allows valid statuses' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        described_class::VALID_STATUSES.each do |state|
          storage_pool[:status] = state
          expect(storage_pool[:status]).to eq(state)
        end
      end

      it 'does not allow invalid statuses' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        expect { storage_pool[:status] = 'Complete' }.to raise_error.with_message(/Invalid status/)
      end
    end

    describe 'undefined methods' do
      it 'does not allow the update action' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        expect { storage_pool.update }.to raise_error(/The method #update is unavailable for this resource/)
      end
    end
  end
end
