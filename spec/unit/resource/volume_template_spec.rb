require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        profile = OneviewSDK::VolumeTemplate.new(@client)
        expect(profile[:type]).to eq('StorageVolumeTemplateV3')
      end
    end
  end

  describe '#set' do
    context 'provisioning' do
      it 'Attributes' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        volume_template[:shareable] = true
        volume_template[:provisionType] = 'Thin'
        volume_template[:capacity] = '1000000'
        volume_template[:storagePoolUri] = ''
        expect(volume_template[:provisioning][:shareable]).to eq(true)
        expect(volume_template[:provisioning][:provisionType]).to eq('Thin')
        expect(volume_template[:provisioning][:capacity]).to eq('1000000')
        expect(volume_template[:provisioning][:storagePoolUri]).to eq('')
      end

      it 'storage pool' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        volume_template.set_storage_pool(uri: '/rest/storage-pools/abc123')
        expect(volume_template[:provisioning]['storagePoolUri']).to eq('/rest/storage-pools/abc123')
      end
    end

    context 'data' do
      it 'storage system' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        volume_template.set_storage_system(uri: '/rest/storage-systems/abc123')
        expect(volume_template['storageSystemUri']).to eq('/rest/storage-systems/abc123')
      end

      it 'snapshot pool' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        volume_template.set_snapshot_pool(uri: '/rest/storage-pools/abc123')
        expect(volume_template['snapshotPoolUri']).to eq('/rest/storage-pools/abc123')
      end
    end
  end

  describe '#validate' do
    context 'provisionType' do
      it 'Valid provisionTypes' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        volume_template[:provisionType] = 'Thin'
        expect(volume_template[:provisioning][:provisionType]).to eq('Thin')
        volume_template[:provisionType] = 'Full'
        expect(volume_template[:provisioning][:provisionType]).to eq('Full')
      end

      it 'Invalid provisionType' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        expect { volume_template[:provisionType] = 'None' }.to raise_error.with_message(/Invalid provisionType/)
      end
    end

    context 'refreshState' do
      it 'allows valid refresh states' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        valid_states = %w(NotRefreshing RefreshFailed RefreshPending Refreshing)
        valid_states.each do |state|
          volume_template[:refreshState] = state
          expect(volume_template[:refreshState]).to eq(state)
        end
      end

      it 'does not allow invalid refresh states' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        expect { volume_template[:refreshState] = 'Complete' }.to raise_error.with_message(/Invalid refresh state/)
      end
    end

    context 'status' do
      it 'allows valid statuses' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        valid_statuses = %w(OK Disabled Warning Critical Unknown)
        valid_statuses.each do |state|
          volume_template[:status] = state
          expect(volume_template[:status]).to eq(state)
        end
      end

      it 'does not allow invalid statuses' do
        volume_template = OneviewSDK::VolumeTemplate.new(@client)
        expect { volume_template[:status] = 'Complete' }.to raise_error.with_message(/Invalid status/)
      end
    end
  end
end
