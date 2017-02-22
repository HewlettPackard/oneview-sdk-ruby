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
      expect { @client.response_handler(resp) }.to raise_error { |e|
        expect(e).to be_a(OneviewSDK::BadRequest)
        expect(e.message).to match(/400 BAD REQUEST.*Blah/)
        expect(e.data).to eq(resp)
      }
    end

    it 'raises an error for 401 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 401)
      expect { @client.response_handler(resp) }.to raise_error { |e|
        expect(e).to be_a(OneviewSDK::Unauthorized)
        expect(e.message).to match(/401 UNAUTHORIZED.*Blah/)
        expect(e.data).to eq(resp)
      }
    end

    it 'raises an error for 404 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 404)
      expect { @client.response_handler(resp) }.to raise_error { |e|
        expect(e).to be_a(OneviewSDK::NotFound)
        expect(e.message).to match(/404 NOT FOUND.*Blah/)
        expect(e.data).to eq(resp)
      }
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
end
