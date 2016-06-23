require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareBundle do
  include_context 'shared context'

  describe '#upload' do
    before :each do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/fake')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(true)
    end

    it 'fails if the file does not exist' do
      expect { described_class.upload(@client, 'file.fake') }.to raise_error(OneviewSDK::NotFound, //)
    end
    it 'returns a FirmwareDriver resource' do
      driver = OneviewSDK::FirmwareBundle.upload(@client, __FILE__)
      expect(driver.class).to eq(OneviewSDK::FirmwareDriver)
      expect(driver['uri']).to eq('/rest/fake')
    end

    it 'recognizes the .zip file format' do
      file = '/tmp/file.zip'
      expect(@client).to receive(:rest_post).with(
        OneviewSDK::FirmwareBundle::BASE_URI,
        hash_including(
          'body' => %r{Content-Type: application/x-zip-compressed\r\n\r\nFAKE FILE CONTENT\r\n--},
          'uploadfilename' => 'file.zip',
          'Content-Type' => "multipart/form-data; boundary=#{OneviewSDK::FirmwareBundle::BOUNDARY}"
        )
      )
      expect(File).to receive('file?').and_return(true)
      allow(File).to receive(:read).and_return('FAKE FILE CONTENT')
      OneviewSDK::FirmwareBundle.upload(@client, file)
    end

    it 'recognizes the .exe file format' do
      file = '/tmp/file.exe'
      expect(@client).to receive(:rest_post).with(
        OneviewSDK::FirmwareBundle::BASE_URI,
        hash_including(
          'body' => %r{Content-Type: application/x-msdownload\r\n\r\nFAKE FILE CONTENT\r\n--},
          'uploadfilename' => 'file.exe',
          'Content-Type' => "multipart/form-data; boundary=#{OneviewSDK::FirmwareBundle::BOUNDARY}"
        )
      )
      expect(File).to receive('file?').and_return(true)
      allow(File).to receive(:read).and_return('FAKE FILE CONTENT')
      OneviewSDK::FirmwareBundle.upload(@client, file)
    end

    it 'defaults to type: application/octet-stream for other files' do
      file = '/tmp/file.tar'
      expect(@client).to receive(:rest_post).with(
        OneviewSDK::FirmwareBundle::BASE_URI,
        hash_including(
          'body' => %r{Content-Type: application/octet-stream\r\n\r\nFAKE FILE CONTENT\r\n--},
          'uploadfilename' => 'file.tar',
          'Content-Type' => "multipart/form-data; boundary=#{OneviewSDK::FirmwareBundle::BOUNDARY}"
        )
      )
      expect(File).to receive('file?').and_return(true)
      allow(File).to receive(:read).and_return('FAKE FILE CONTENT')
      OneviewSDK::FirmwareBundle.upload(@client, file)
    end
  end
end
