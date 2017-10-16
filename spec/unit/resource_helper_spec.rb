require_relative './../spec_helper'

# Tests for the ResourceHelper module
RSpec.describe OneviewSDK::ResourceHelper do
  include_context 'shared context'
  class SomeIncluder < OneviewSDK::Resource
    include OneviewSDK::ResourceHelper::PatchOperation
  end

  class SomeIncluderConfigurationOperation < OneviewSDK::Resource
    include OneviewSDK::ResourceHelper::ConfigurationOperation
  end

  subject(:klass) { SomeIncluder.new(@client_200) }

  describe '#patch' do
    it 'requires a uri' do
      item = SomeIncluder.new(@client_200)
      expect { item.patch('replace', '/path', 'any') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'executing a patch' do
      item = SomeIncluder.new(@client_200, uri: '/rest/fake', eTag: 'anyTag')
      options = {
        'If-Match' => item['eTag'],
        'body' => [{ op: 'replace', path: '/path', value: 'val' }]
      }
      expect(@client_200).to receive(:rest_patch).with(item['uri'], options, item.api_version).and_return(FakeResponse.new)
      allow_any_instance_of(SomeIncluder).to receive(:retrieve!).and_return(true)
      item.patch('replace', '/path', 'val', 'If-Match' => item['eTag'])
    end
  end

  describe '#configuration' do
    it 'requires a uri' do
      item = SomeIncluderConfigurationOperation.new(@client_200)
      expect { item.configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'applying configuration' do
      item = SomeIncluderConfigurationOperation.new(@client_200, uri: '/rest/fake/1')
      allow_any_instance_of(SomeIncluderConfigurationOperation).to receive(:retrieve!).and_return(true)
      allow(@client_200).to receive(:response_handler)
      expect(@client_200).to receive(:rest_put).with('/rest/fake/1/configuration', {}, item.api_version).and_return(FakeResponse.new)
      expect(item).to receive(:set_all)
      item.configuration
    end
  end
end
