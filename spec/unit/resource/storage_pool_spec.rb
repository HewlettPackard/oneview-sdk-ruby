require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool do
  include_context 'shared context'

  describe '#initialize' do
    context 'Defaults' do
      it 'sets the defaults correctly' do
        profile = OneviewSDK::StoragePool.new(@client)
        expect(profile[:type]).to eq('StoragePoolV2')
      end
    end
  end

  describe '#validate' do
    context 'refreshState' do
      it 'Valid input' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        storage_pool[:refreshState] = 'NotRefreshing'
        expect(storage_pool[:refreshState]).to eq('NotRefreshing')
        storage_pool[:refreshState] = 'RefreshFailed'
        expect(storage_pool[:refreshState]).to eq('RefreshFailed')
        storage_pool[:refreshState] = 'RefreshPending'
        expect(storage_pool[:refreshState]).to eq('RefreshPending')
        storage_pool[:refreshState] = 'Refreshing'
        expect(storage_pool[:refreshState]).to eq('Refreshing')
      end
      it 'Invalid input' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        expect { storage_pool[:refreshState] = 'Complete' }.to raise_error.with_message(/Invalid refresh state/)
      end
    end

    context 'status' do
      it 'Valid input' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        storage_pool[:status] = 'OK'
        expect(storage_pool[:status]).to eq('OK')
        storage_pool[:status] = 'Disabled'
        expect(storage_pool[:status]).to eq('Disabled')
        storage_pool[:status] = 'Warning'
        expect(storage_pool[:status]).to eq('Warning')
        storage_pool[:status] = 'Critical'
        expect(storage_pool[:status]).to eq('Critical')
        storage_pool[:status] = 'Unknown'
        expect(storage_pool[:status]).to eq('Unknown')
      end
      it 'Invalid input' do
        storage_pool = OneviewSDK::StoragePool.new(@client)
        expect { storage_pool[:status] = 'Complete' }.to raise_error.with_message(/Invalid status/)
      end
    end
  end

end
