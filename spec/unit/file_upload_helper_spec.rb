require_relative './../spec_helper'

# Tests for the FileUploadHelper module
RSpec.describe OneviewSDK::FileUploadHelper do
  include_context 'shared context'

  describe 'upload_file'do
    it 'raises an exception when file does not exist' do
      expect { OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip') }.to raise_error(OneviewSDK::NotFound, //)
    end

    it 'should use default http read_timeout when new value is not passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
        .and_return(FakeResponse.new)
      OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip')
      expect(http_fake).to have_received(:read_timeout=).with(OneviewSDK::FileUploadHelper::READ_TIMEOUT)
    end

    it 'should use value of http read_timeout passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
        .and_return(FakeResponse.new)
      OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip', {}, 600)
      expect(http_fake).to have_received(:read_timeout=).with(600)
    end
  end

end
