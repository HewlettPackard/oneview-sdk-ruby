require_relative './../spec_helper'

# Tests for the Rest module
RSpec.describe OneviewSDK::Client do
  include_context 'shared context'

  let(:path) { '/rest/resources/fake' }
  let(:data) { { 'name' => 'Fake', 'description' => 'Fake Resource', 'uri' => path } }

  describe '#rest_api' do
    before :each do
      fake_response = FakeResponse.new({ name: 'New' }, 200, location: path)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_response)
    end

    it 'requires a path' do
      expect { @client.rest_api(:get, nil) }.to raise_error(OneviewSDK::InvalidRequest, /Must specify path/)
    end

    it 'logs the request type and path (debug level)' do
      @client.logger.level = @client.logger.class.const_get('DEBUG')
      %w(get post put patch delete).each do |type|
        expect { @client.rest_api(type, path) }
          .to output(/Making :#{type} rest call to #{@client.url + path}/).to_stdout_from_any_process
      end
    end

    it 'raises an error when the ssl validation fails' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(OpenSSL::SSL::SSLError, 'Msg')
      expect(@client.logger).to receive(:error).with(/SSL verification failed/)
      expect { @client.rest_api(:get, path) }.to raise_error(OpenSSL::SSL::SSLError)
    end

    it 'respects the client.timeout value' do
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com', token: 'secret123', timeout: 5)
      expect_any_instance_of(Net::HTTP).to receive(:read_timeout=).with(5).and_call_original
      expect_any_instance_of(Net::HTTP).to receive(:open_timeout=).with(5).and_call_original
      client.rest_api(:get, path)
    end

    it 'supports following redirects' do
      http = Net::HTTP.new('oneview.example.com', 443) # Needed to mock multiple method calls
      expect(Net::HTTP).to receive(:new).twice.and_return(http)
      response1 = FakeResponse.new({ name: 'New' }, 301, 'location' => path)
      expect(response1).to receive(:class).and_return(Net::HTTPRedirection) # Simulate 301 on first request
      response2 = FakeResponse.new({ name: 'New' }, 200)
      expect(http).to receive(:request).and_return(response1, response2)
      r = @client.rest_api(:get, path)
      expect(r).to eq(response2)
    end

    it 'follows a limited number of redirects' do
      response = FakeResponse.new({ name: 'New' }, 301, 'location' => path)
      allow(response.class).to receive(:<=).with(Net::HTTPRedirection).and_return(true)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
      expect(@client).to receive(:rest_api).exactly(4).times.and_call_original
      r = @client.rest_api(:get, path)
      expect(r).to eq(response)
    end

    it 'only follows redirects if there is a location header' do
      response = FakeResponse.new({ name: 'New' }, 301)
      allow(response.class).to receive(:<=).with(Net::HTTPRedirection).and_return(true)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
      expect(@client).to receive(:rest_api).once.and_call_original
      @client.rest_api(:get, path)
    end
  end

  describe '#rest_get' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:get, path, {}, @client.api_version)
      @client.rest_get(path)
    end
  end

  describe '#rest_post' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:post, path, { body: data }, @client.api_version)
      @client.rest_post(path, { body: data }, @client.api_version)
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:post, path, {}, @client.api_version)
      @client.rest_post(path)
    end
  end

  describe '#rest_put' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:put, path, {}, @client.api_version)
      @client.rest_put(path, {}, @client.api_version)
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:put, path, {}, @client.api_version)
      @client.rest_put(path)
    end
  end

  describe '#rest_patch' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:patch, path, {}, @client.api_version)
      @client.rest_patch(path, {}, @client.api_version)
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:patch, path, {}, @client.api_version)
      @client.rest_patch(path)
    end
  end

  describe '#rest_delete' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:delete, path, {}, @client.api_version)
      @client.rest_delete(path, {}, @client.api_version)
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:delete, path, {}, @client.api_version)
      @client.rest_delete(path)
    end
  end

  describe '#response_handler' do
    it 'returns the JSON-parsed body for 200 status' do
      expect(@client.response_handler(FakeResponse.new(data))).to eq(data)
    end

    it 'returns the JSON-parsed body for 201 status' do
      expect(@client.response_handler(FakeResponse.new(data, 201))).to eq(data)
    end

    it 'waits on the task completion for 202 status' do
      initial_response = FakeResponse.new(data, 202, 'location' => '/rest/task/fake')

      wait_response = FakeResponse.new({}, 200, 'associatedResource' => { 'resourceUri' => data['uri'] })
      expect(@client).to receive(:wait_for).with('/rest/task/fake').and_return(wait_response)

      expect(@client).to receive(:rest_get).with(data['uri']).and_return(FakeResponse.new(data))
      expect(@client.response_handler(initial_response)).to eq(data)
    end

    it 'allows you to set wait_for_task to false' do
      response = FakeResponse.new(data, 202, 'location' => '/rest/task/fake')
      expect(@client.response_handler(response, false)).to eq(data)
    end

    it 'returns an empty hash for 204 status' do
      expect(@client.response_handler(FakeResponse.new({}, 204))).to eq({})
    end

    it 'raises an error for 400 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 400)
      expect { @client.response_handler(resp) }.to raise_error(OneviewSDK::BadRequest, /400 BAD REQUEST.*Blah/)
    end

    it 'raises an error for 401 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 401)
      expect { @client.response_handler(resp) }.to raise_error(OneviewSDK::Unauthorized, /401 UNAUTHORIZED.*Blah/)
    end

    it 'raises an error for 404 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 404)
      expect { @client.response_handler(resp) }.to raise_error(OneviewSDK::NotFound, /404 NOT FOUND.*Blah/)
    end

    it 'raises an error for undefined status codes' do
      [0, 19, 199, 203, 399, 402, 500].each do |status|
        resp = FakeResponse.new({ message: 'Blah' }, status)
        expect { @client.response_handler(resp) }.to raise_error(OneviewSDK::RequestError, /#{status}.*Blah/)
      end
    end
  end

  describe '#build_request' do
    before :each do
      @uri = URI.parse(URI.escape(@client.url + path))
      @options = {
        'X-API-Version' => @client.api_version,
        'auth' => @client.token
      }
    end

    it 'fails when an invalid request type is given' do
      expect { @client.send(:build_request, :fake, @uri, {}, @client.api_version) }.to raise_error(OneviewSDK::InvalidRequest, /Invalid rest method/)
    end

    context 'default header values' do
      before :each do
        @req = @client.send(:build_request, :get, @uri, {}, @client.api_version)
      end

      it 'sets the X-API-Version' do
        expect(@req['x-api-version']).to eq(@client.api_version.to_s)
      end

      it 'sets the auth token' do
        expect(@req['auth']).to eq(@client.token)
      end

      it 'sets the Content-Type' do
        expect(@req['Content-Type']).to eq('application/json')
      end
    end

    it 'allows deletion of default headers' do
      options = { 'Content-Type' => :none, 'X-API-Version' => :none, 'auth' => 'none' }
      req = @client.send(:build_request, :get, @uri, options, @client.api_version)
      expect(req['Content-Type']).to eq(nil)
      expect(req['x-api-version']).to eq(nil)
      expect(req['auth']).to eq(nil)
    end

    it 'allows additional headers to be set' do
      options = { 'My-Header' => 'blah' }
      req = @client.send(:build_request, :get, @uri, options, @client.api_version)
      expect(req['My-Header']).to eq('blah')
    end

    it 'sets the body option to the request body' do
      options = { 'body' => { name: 'New', uri: path } }
      req = @client.send(:build_request, :get, @uri, options, @client.api_version)
      expect(req.body).to eq(options['body'].to_json)
    end

    it 'logs the request options (debug level)' do
      def_options = { 'X-API-Version' => @client.api_version, 'auth' => 'secretToken', 'Content-Type' => 'application/json' }
      @client.logger.level = @client.logger.class.const_get('DEBUG')
      expect { @client.send(:build_request, :get, @uri, {}, @client.api_version) }
        .to output(/Options: #{def_options}/).to_stdout_from_any_process
    end
  end

  describe 'upload_file' do
    context 'when file does not exist' do
      it 'should raise exception' do
        expect { @client.upload_file('file.zip', '/uri') }.to raise_error(OneviewSDK::NotFound, //)
      end
    end

    it 'should use default parameter values' do
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      http_fake = spy('http')
      allow(Net::HTTP).to receive(:new).and_return(http_fake)
      allow(@client).to receive(:response_handler).and_return(FakeResponse.new)
      @client.upload_file('file.zip', '/uri-file-upload')
      expect(http_fake).to have_received(:read_timeout=).with(OneviewSDK::Rest::READ_TIMEOUT)
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

      @client.upload_file('file.zip', '/uri-file-upload', { 'name' => 'TestName' }, 600)

      expected_options = { 'Content-Type' => 'multipart/form-data', 'X-Api-Version' => @client.api_version.to_s, 'auth' => @client.token }
      expect(Net::HTTP::Post::Multipart).to have_received(:new)
        .with('/uri-file-upload', { 'file' => 'Fake_File_IO' }, expected_options)
      expect(http_fake).to have_received(:read_timeout=).with(600)
    end

    it 'upload a file' do
      options = { name: 'fake' }
      fake_response = FakeResponse.new(name: 'fake', uri: 'rest/fake/1')
      expected_result = { 'name' => 'fake', 'uri' => 'rest/fake/1' }
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_response)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(@client_i3s_300).to receive(:response_handler).with(fake_response).and_return(expected_result)
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      result = @client.upload_file('file.zip', 'rest/fake/1', options)
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

      expect(@client).to receive(:build_request)
      expect(@client).not_to receive(:response_handler)

      result = @client.download_file('/file-download-uri', 'file.zip')
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

        expect { @client.download_file('/file-download-uri', 'file.zip') }.to raise_error(OneviewSDK::BadRequest)
      end
    end
  end

  describe '#build_http_object' do
    context 'with ssl enabled and timeout variable defined' do
      it 'should create a http object with valid data' do
        uri = URI.parse('https://localhost:1000')
        @client.ssl_enabled = true
        @client.cert_store = 'some_certificate'
        @client.timeout = 300

        http = @client.send(:build_http_object, uri)

        expect(http.address).to eq('localhost')
        expect(http.port).to eq(1000)
        expect(http.read_timeout).to eq(300)
        expect(http.open_timeout).to eq(300)
        expect(http.verify_mode).not_to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(http.cert_store).to eq('some_certificate')
        expect(http.use_ssl?).to eq(true)
      end
    end

    context 'without ssl enabled and timeout variable defined' do
      it 'should create a http object with valid data' do
        http_default = Net::HTTP.new('http://localhost')
        uri = URI.parse('http://localhost:1000')
        @client.ssl_enabled = false

        http = @client.send(:build_http_object, uri)

        expect(http.address).to eq('localhost')
        expect(http.port).to eq(1000)
        expect(http.read_timeout).to eq(http_default.read_timeout)
        expect(http.open_timeout).to eq(http_default.open_timeout)
        expect(http.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(http.cert_store).to eq(http_default.cert_store)
        expect(http.use_ssl?).to eq(false)
      end
    end
  end
end
