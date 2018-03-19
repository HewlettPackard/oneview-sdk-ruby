require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::Enclosure' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Enclosure
  end

  describe '#initialize' do
    context 'OneView 4.00' do
      it 'sets the defaults correctly' do
        enclosure = described_class.new(@client_600)
        expect(enclosure[:type]).to eq('EnclosureListV7')
      end
    end
  end

  describe '#create_csr_request' do
    it 'calls the /https/certificaterequest uri' do
      enclosure = described_class.new(@client_600, uri: '/rest/enclosures/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new)
      expect(@client_600).to receive(:rest_post).with('/rest/enclosures/fake/https/certificaterequest', { 'body' => 'New' },
                                                      @client_600.api_version)
      enclosure.create_csr_request('New')
    end
  end

  describe '#get_csr_request' do
    it 'calls the /https/certificaterequest uri' do
      enclosure = described_class.new(@client_600, uri: '/rest/enclosures/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new)
      expect(@client_600).to receive(:rest_get).with('/rest/enclosures/fake/https/certificaterequest', {},
                                                     @client_600.api_version)
      expect(enclosure.get_csr_request)
    end
  end

  describe '#import_certificate' do
    it 'calls the /https/certificaterequest uri' do
      enclosure = described_class.new(@client_600, uri: '/rest/enclosures/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
      expect(@client_600).to receive(:rest_put).with('/rest/enclosures/fake/https/certificaterequest', { 'body' => 'New' },
                                                     @client_600.api_version)
      enclosure.import_certificate('body' => 'New')
    end
  end
end
