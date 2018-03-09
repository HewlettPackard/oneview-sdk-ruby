require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::VolumeTemplate do
  include_context 'shared context'

  subject(:item) { described_class.new(@client_500, uri: '/rest/storage-volume-templates/UUID-111') }

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Resource
  end

  it 'should have correct base URI' do
    expect(described_class::BASE_URI).to eq('/rest/storage-volume-templates')
  end

  describe '#delete' do
    it 'is should call rest api correctly' do
      fake_response = FakeResponse.new
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(@client_500).to receive(:rest_delete).with('/rest/storage-volume-templates/UUID-111', { 'If-Match' => 'eTag key' }, 500)
                                                  .and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response)
      item['eTag'] = 'eTag key'
      expect(item.delete).to eq(true)
    end
  end

  describe '#set_root_template' do
    it 'should set properties and rootTemplateUri attributes' do
      root_template = described_class.new(@client_500, properties: { 'isShareable' => 'some_object' }, uri: '/rest/storage-volume-templates/root')
      item.set_root_template(root_template)
      expect(item['properties']).to eq('isShareable' => 'some_object')
      expect(item['rootTemplateUri']).to eq('/rest/storage-volume-templates/root')
    end
  end

  describe '#lock' do
    let(:properties) { { 'isShareable' => { 'meta' => { 'locked' => nil } } } }

    it 'should change the correct lock property to true' do
      item['properties'] = properties
      item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
      item.lock('isShareable')
      expect(item['properties']['isShareable']['meta']['locked']).to eq(true)
    end

    context 'when set lock to false' do
      it 'should change the correct locked property to false' do
        item['properties'] = properties
        item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
        item.lock('isShareable', false)
        expect(item['properties']['isShareable']['meta']['locked']).to eq(false)
      end
    end

    context 'when root template or properties is not set' do
      it 'should raise IncompleteResource error' do
        expect { item.lock('isShareable') }.to raise_error(OneviewSDK::IncompleteResource, /Must set a valid root template/)
      end
    end
  end

  describe '#unlock' do
    let(:properties) { { 'isShareable' => { 'meta' => { 'locked' => true } } } }

    it 'should change the correct locked property to false' do
      item['properties'] = properties
      item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
      item.unlock('isShareable')
      expect(item['properties']['isShareable']['meta']['locked']).to eq(false)
    end

    context 'when root template or properties is not set' do
      it 'should raise IncompleteResource error' do
        expect { item.unlock('isShareable') }.to raise_error(OneviewSDK::IncompleteResource, /Must set a valid root template/)
      end
    end
  end

  describe '#locked?' do
    let(:properties) { { 'isShareable' => { 'meta' => { 'locked' => true } } } }

    it 'should return the value of locked property' do
      item['properties'] = properties
      item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
      expect(item.locked?('isShareable')).to eq(true)
    end

    context 'when root template or properties is not set' do
      it 'should raise IncompleteResource error' do
        expect { item.locked?('isShareable') }.to raise_error(OneviewSDK::IncompleteResource, /Must set a valid root template/)
      end
    end
  end

  describe '#set_default_value' do
    let(:properties) { { 'isShareable' => { 'default' => true } } }

    it 'should set the default value of a property' do
      item['properties'] = properties
      item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
      item.set_default_value('isShareable', false)
      expect(item['properties']['isShareable']['default']).to eq(false)
    end

    context 'when root template or properties is not set' do
      it 'should raise IncompleteResource error' do
        expect { item.set_default_value('isShareable', false) }.to raise_error(OneviewSDK::IncompleteResource, /Must set a valid root template/)
      end
    end
  end

  describe '#get_default_value' do
    let(:properties) { { 'isShareable' => { 'default' => true } } }

    it 'should return the default value of a property' do
      item['properties'] = properties
      item['rootTemplateUri'] = '/rest/storage-volume-templates/root'
      expect(item.get_default_value('isShareable')).to eq(true)
    end

    context 'when root template or properties is not set' do
      it 'should raise IncompleteResource error' do
        expect { item.set_default_value('isShareable', false) }.to raise_error(OneviewSDK::IncompleteResource, /Must set a valid root template/)
      end
    end
  end

  describe '#get_compatible_systems' do
    it 'should call the api correct' do
      storage_systems_uri = 'rest/storage-systems/1'
      item['compatibleStorageSystemsUri'] = storage_systems_uri
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(described_class).to receive(:find_with_pagination).with(@client_500, storage_systems_uri).and_return(['object 1', 'object 2'])
      expect(item.get_compatible_systems).to eq(['object 1', 'object 2'])
    end
  end

  describe '::get_reachable_volume_templates' do
    it 'should call the api correct' do
      expect(described_class).to receive(:find_by).with(@client_500, {}, '/rest/storage-volume-templates/reachable-volume-templates')
      described_class.get_reachable_volume_templates(@client_500)
    end

    context 'when pass networks to paramaters list' do
      it 'should call the api correct' do
        expect(described_class).to receive(:find_by)
          .with(@client_500, {}, "/rest/storage-volume-templates/reachable-volume-templates?networks='/rest/fc-networks/1,/rest/fc-networks/2'")
        network_1 = OneviewSDK::API500::C7000::FCNetwork.new(@client_500, uri: '/rest/fc-networks/1')
        network_2 = OneviewSDK::API500::C7000::FCNetwork.new(@client_500, uri: '/rest/fc-networks/2')
        described_class.get_reachable_volume_templates(@client_500, [network_1, network_2])
      end
    end

    context 'when pass attributes to paramaters list' do
      it 'should call the api correct' do
        expect(described_class).to receive(:find_by)
          .with(@client_500, { some_attribute: 'some value' }, '/rest/storage-volume-templates/reachable-volume-templates')
        described_class.get_reachable_volume_templates(@client_500, [], some_attribute: 'some value')
      end
    end
  end
end
