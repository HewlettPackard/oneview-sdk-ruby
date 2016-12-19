require 'spec_helper'
require 'net/http/post/multipart'

RSpec.describe OneviewSDK::API300::C7000::FirmwareBundle do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::FirmwareBundle
  end

  describe '#add' do
    it 'fails if the file does not exist' do
      expect { described_class.add(@client_300, 'file.fake') }.to raise_error(OneviewSDK::NotFound, //)
    end

    it 'returns a FirmwareDriver resource' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(FakeResponse.new({}, 200))
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(@client_300).to receive(:response_handler).and_return(uri: '/rest/firmware-drivers/f1')
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.tar').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      expect(described_class.add(@client_300, 'file.tar').class).to eq(OneviewSDK::FirmwareDriver)
    end

    it 'should use default http read_timeout when new value is not passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.tar').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      described_class.add(@client, 'file.tar')
      expect(http_fake).to have_received(:read_timeout=).with(described_class::READ_TIMEOUT)
    end

    it 'should use value of http read_timeout passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.tar').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      described_class.add(@client, 'file.tar', 600)
      expect(http_fake).to have_received(:read_timeout=).with(600)
    end
  end
end
