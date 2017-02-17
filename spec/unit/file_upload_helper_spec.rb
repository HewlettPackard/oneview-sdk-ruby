require_relative './../spec_helper'

# Tests for the FileUploadHelper module
RSpec.describe OneviewSDK::FileUploadHelper do
  include_context 'shared context'

  describe 'upload_file' do
    context 'when file does not exist' do
      it 'should raise exception' do
        expect { OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip', '/uri') }.to raise_error(OneviewSDK::NotFound, //)
      end
    end

    it 'should use default parameter values' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
        .and_return(FakeResponse.new)
      OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip', '/uri-file-upload')
      expect(http_fake).to have_received(:read_timeout=).with(OneviewSDK::FileUploadHelper::READ_TIMEOUT)
    end

    it 'should use value of passed as parameter' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('Fake_File_IO')
      allow(Net::HTTP::Post::Multipart).to receive(:new)
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
        .and_return(FakeResponse.new)

      OneviewSDK::FileUploadHelper.upload_file(@client, 'file.zip', '/uri-file-upload', { 'name' => 'TestName' }, 600)

      expected_options = { 'Content-Type' => 'multipart/form-data', 'X-Api-Version' => @client.api_version.to_s, 'auth' => @client.token }
      expect(Net::HTTP::Post::Multipart).to have_received(:new)
        .with('/uri-file-upload', { 'file' => 'Fake_File_IO' }, expected_options)
      expect(http_fake).to have_received(:read_timeout=).with(600)
    end

    it 'upload a file' do
      options = { name: 'fake', description: 'anything' }
      fake_response = FakeResponse.new(name: 'fake', uri: 'rest/fake/1')
      expected_result = { name: 'fake', description: 'anything', uri: 'rest/fake/1' }
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_response)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(@client_i3s_300).to receive(:response_handler).with(fake_response).and_return(expected_result)
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      result = OneviewSDK::FileUploadHelper.upload_file(@client_i3s_300, 'file.zip', 'rest/fake/1', options)
      expect(result).to eq(expected_result)
    end
  end

  describe '::download_file' do
    it 'should download file correctly' do
      http_fake = spy('http')
      http_response_fake = spy('http_response')
      file_fake = spy('file')
      stream_fake = spy('stream_segment')

      expect(Net::HTTP).to receive(:new).and_return(http_fake)
      expect(http_fake).to receive(:start).and_yield(http_fake)
      expect(http_fake).to receive(:request).and_yield(http_response_fake)
      expect(http_response_fake).to receive(:code).and_return(200) # != 200..204
      expect(File).to receive(:open).with('file.zip', 'wb').and_yield(file_fake)
      expect(http_response_fake).to receive(:read_body).and_yield(stream_fake)
      expect(file_fake).to receive(:write).with(stream_fake)

      expect(Net::HTTP::Get).to receive(:new)
        .with('/file-download-uri', 'Content-Type' => 'application/json', 'X-Api-Version' => @client.api_version.to_s, 'auth' => @client.token)
      expect(@client).not_to receive(:response_handler)

      result = OneviewSDK::FileUploadHelper.download_file(@client, '/file-download-uri', 'file.zip')
      expect(result).to eq(true)
    end

    context 'when http response has a status error' do
      it 'should call response_handler from client class' do
        http_fake = spy('http')
        http_response_fake = spy('http_response')

        allow(Net::HTTP).to receive(:new).and_return(http_fake)
        allow(http_fake).to receive(:start).and_yield(http_fake)
        allow(http_fake).to receive(:request).and_yield(http_response_fake)
        allow(http_response_fake).to receive(:code).and_return(400) # != 200..204

        expect { OneviewSDK::FileUploadHelper.download_file(@client, '/file-download-uri', 'file.zip') }.to raise_error(OneviewSDK::BadRequest)
      end
    end
  end

end
