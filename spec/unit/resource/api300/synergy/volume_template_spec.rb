require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::VolumeTemplate do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::VolumeTemplate
  end

  let(:fake_storage_pool) do
    {
      'name' => 'fake_storage_pool',
      'uri' => '/rest/storage-pools/fake_uri'
    }
  end

  let(:fake_storage_system) do
    {
      'name' => 'fake_storage_system',
      'uri' => '/rest/storage-systems/fake_uri'
    }
  end

  let(:fake_snapshot_pool) do
    {
      'name' => 'fake_snapshot_pool',
      'uri' => '/rest/storage-systems/snapshot-pools/fake_uri'
    }
  end


  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300)
      expect(profile[:type]).to eq('StorageVolumeTemplateV3')
    end
  end

  describe '#create' do
    it 'adds a language header to the request' do
      item = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300, name: 'Fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(true)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/fake')
      expect(@client_300).to receive(:rest_post).with(
        '/rest/storage-volume-templates',
        { 'Accept-Language' => 'en_US', 'body' => item.data },
        item.api_version
      )
      item.create
      expect(item['uri']).to eq('/rest/fake')
    end
  end

  describe '#update' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300).update }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'updates the name of the volume template' do
      item = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300, uri: '/rest/fake', name: 'Fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(true)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).with(true).and_return(item['name'] = 'Fake2')
      expect(@client_300).to receive(:rest_put).with(
        '/rest/fake',
        { 'Accept-Language' => 'en_US', 'body' => item.data },
        item.api_version
      )
      item.update

      expect(item['name']).to eq('Fake2')
    end
  end

  describe '#delete' do
    it 'adds a language header to the request' do
      item = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300, name: 'Fake', uri: '/rest/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(true)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      expect(@client_300).to receive(:rest_delete).with(
        '/rest/fake',
        { 'Accept-Language' => 'en_US' },
        item.api_version
      )
      item.delete
    end
  end

  describe '#set' do
    context 'provisioning' do
      it 'Attributes' do
        volume_template = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300)
        volume_template.set_provisioning(true, 'Thin', '10737418240', fake_storage_pool)
        expect(volume_template['provisioning']['shareable']).to eq(true)
        expect(volume_template['provisioning']['provisionType']).to eq('Thin')
        expect(volume_template['provisioning']['capacity']).to eq('10737418240')
        expect(volume_template['provisioning']['storagePoolUri']).to eq('/rest/storage-pools/fake_uri')
      end
    end

    context 'data' do
      it 'storage system' do
        volume_template = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300)
        volume_template.set_storage_system(fake_storage_system)
        expect(volume_template['storageSystemUri']).to eq('/rest/storage-systems/fake_uri')
      end

      it 'snapshot pool' do
        volume_template = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300)
        volume_template.set_snapshot_pool(fake_snapshot_pool)
        expect(volume_template['snapshotPoolUri']).to eq('/rest/storage-systems/snapshot-pools/fake_uri')
      end
    end
  end

  describe '#get_connectable_volume_templates' do
    it 'gets the connectable volume templates by its attributes' do
      volume_template = OneviewSDK::API300::Synergy::VolumeTemplate.new(@client_300)
      allow(OneviewSDK::Resource)
        .to receive(:find_by).with(@client_300, {}, '/rest/storage-volume-templates/connectable-volume-templates').and_return('fake')
      expect(volume_template.get_connectable_volume_templates).to eq('fake')
    end
  end
end
