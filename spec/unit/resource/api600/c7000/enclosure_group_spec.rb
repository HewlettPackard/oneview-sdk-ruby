require 'spec_helper'

klass = OneviewSDK::API600::C7000::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::EnclosureGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_600)
      expect(item[:enclosureCount]).to eq(1)
    end
  end

  describe '#update' do
    it 'updating an enclosure group' do
      item = klass.new(@client_600, name: 'Name', uri: '/rest/fake', 'eTag' => 'anyTag')
      options = { 'name' => 'Name_Updated', 'uri' => '/rest/fake', 'eTag' => 'anyTag' }
      resp = FakeResponse.new(options)
      expect(@client_600).to receive(:rest_put).with(item['uri'], { 'body' => item.data }, item.api_version).and_return(resp)
      allow(klass).to receive(:find_by).and_return([klass.new(@client_600, options.merge('eTag' => 'anotherTag'))])
      item = item.update(name: 'Name_Updated')
      expect(item['name']).to eq(options['name'])
      expect(item['uri']).to eq(options['uri'])
      expect(item['eTag']).to eq('anotherTag')
    end
  end
end
