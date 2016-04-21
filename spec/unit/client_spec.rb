require_relative './../spec_helper'

RSpec.describe OneviewSDK::Client do

  describe '#initialize' do
    it 'creates a client with valid credentials' do
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to_not be_nil
    end

    it 'creates a client with a token' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('token123')
    end

    it 'requires a token or user-password pair' do
      options = { url: 'https://oneview.example.com', user: 'Administrator' }
      expect { OneviewSDK::Client.new(options) }.to raise_error(/Must set user & password options or token/)
    end

    it 'requires the url attribute to be set' do
      expect { OneviewSDK::Client.new({}) }.to raise_error(/Must set the url option/)
    end

    it 'sets the username to "Administrator" by default' do
      options = { url: 'https://oneview.example.com', password: 'secret123' }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/User option not set. Using default/).to_stdout_from_any_process
      expect(client.user).to eq('Administrator')
    end

    it 'respects credential environment variables' do
      ENV['ONEVIEWSDK_USER'] = 'Admin'
      ENV['ONEVIEWSDK_PASSWORD'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.user).to eq('Admin')
      expect(client.password).to eq('secret456')
    end

    it 'respects the token environment variable' do
      ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.token).to eq('secret456')
    end

    it 'respects the ssl environment variable' do
      ENV['ONEVIEWSDK_SSL_ENABLED'] = 'false'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com', token: 'secret123')
      expect(client.ssl_enabled).to eq(false)
    end

    it 'requires a valid ssl environment variable value' do
      ENV['ONEVIEWSDK_SSL_ENABLED'] = 'bad'
      options = { url: 'https://oneview.example.com', token: 'secret123' }
      expect { OneviewSDK::Client.new(options) }.to output(/Unrecognized ssl_enabled value/).to_stdout_from_any_process
    end

    it 'sets the log level' do
      options = { url: 'https://oneview.example.com', password: 'secret123', log_level: :error }
      client = OneviewSDK::Client.new(options)
      expect(client.log_level).to eq(:error)
      expect(client.logger.level).to eq(3)
    end

    it 'picks the lower of the default api version and appliance api version' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(120)
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.api_version).to eq(120)
    end

    it 'warns if the api level is greater than the appliance api version' do
      options = { url: 'https://oneview.example.com', token: 'token123', api_version: 300 }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/is greater than the appliance API version/).to_stdout_from_any_process
      expect(client.api_version).to eq(300)
    end

    it 'sets @print_wait_dots to false by default' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.print_wait_dots).to be false
    end

    it 'allows @print_wait_dots to be set to true' do
      options = { url: 'https://oneview.example.com', token: 'token123', print_wait_dots: true }
      client = OneviewSDK::Client.new(options)
      expect(client.print_wait_dots).to be true
    end

    it 'sets the @cert_store variable' do
      expect(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return :fake
      options = { url: 'https://oneview.example.com', token: 'token123', ssl_enabled: true }
      client = OneviewSDK::Client.new(options)
      expect(client.cert_store).to eq(:fake)
    end

    it 'does not set the @cert_store variable when ssl is disabled' do
      expect(OneviewSDK::SSLHelper).to_not receive(:load_trusted_certs)
      options = { url: 'https://oneview.example.com', token: 'token123', ssl_enabled: false }
      client = OneviewSDK::Client.new(options)
      expect(client.cert_store).to eq(nil)
    end
  end

  describe '#appliance_api_version' do
    before :each do
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_call_original
    end

    it 'gets the api version from the appliance' do
      fake_response = FakeResponse.new('currentVersion' => '120')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(fake_response)
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.api_version).to eq(120)
    end

    it 'sets a default api version value when it cannot be obtained from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(FakeResponse.new)
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(
        /Failed to get OneView max api version. Using default/).to_stdout_from_any_process
      expect(client.api_version).to eq(200)
    end
  end

  describe '#login' do
    before :each do
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_call_original
    end

    it 'gets a token from the appliance' do
      fake_response = FakeResponse.new(sessionID: 'secret789')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(fake_response)
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('secret789')
    end

    it 'tries twice to get a token from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(FakeResponse.new)
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', log_level: :debug }
      expect { OneviewSDK::Client.new(options) rescue nil }.to output(/Retrying.../).to_stdout_from_any_process
      options.delete(:log_level)
      expect { OneviewSDK::Client.new(options) }.to raise_error(/Couldn't log into OneView server/)
    end
  end

  describe 'resource action methods' do
    include_context 'shared context'

    before :each do
      @resource = OneviewSDK::Resource.new(@client)
    end

    it 'implements the #create method' do
      expect(@resource).to receive(:create)
      @client.create(@resource)
    end

    it 'implements the #save method' do
      expect(@resource).to receive(:save)
      @client.save(@resource)
    end

    it 'implements the #update method' do
      expect(@resource).to receive(:update)
      @client.update(@resource, name: 'NewName')
    end

    it 'implements the #refresh method' do
      expect(@resource).to receive(:refresh)
      @client.refresh(@resource)
    end

    it 'implements the #delete method' do
      expect(@resource).to receive(:delete)
      @client.delete(@resource)
    end
  end

  describe '#get_all' do
    include_context 'shared context'

    it "calls the correct resource's get_all method" do
      expect(OneviewSDK::ServerProfile).to receive(:get_all).with(@client)
      @client.get_all('ServerProfiles')
    end

    it 'fails when a bogus resource type is given' do
      expect { @client.get_all('BogusResources') }.to raise_error(/Invalid resource type/)
    end
  end

  describe '#wait_for' do
    include_context 'shared context'

    it 'requires a task_uri' do
      expect { @client.wait_for('') }.to raise_error(/Must specify a task_uri/)
    end

    it 'returns the response body for completed tasks' do
      fake_response = FakeResponse.new(taskState: 'Completed', name: 'NewName')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
      ret = @client.wait_for('/rest/tasks/1')
      expect(ret).to eq('taskState' => 'Completed', 'name' => 'NewName')
    end

    it 'shows warnings' do
      fake_response = FakeResponse.new(taskState: 'Warning', taskErrors: 'Blah')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
      ret = nil
      expect { ret = @client.wait_for('/rest/tasks/1') }.to output(/ended with warning.*Blah/).to_stdout_from_any_process
      expect(ret).to eq('taskState' => 'Warning', 'taskErrors' => 'Blah')
    end

    it 'raises an error if the task fails' do
      %w(Error Killed Terminated).each do |state|
        fake_response = FakeResponse.new(taskState: state, message: 'Blah')
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
        expect { @client.wait_for('/rest/tasks/1') }.to raise_error(/ended with bad state[\S\s]*Blah/)
      end
    end

    it 'raises an error with the error details if the task fails' do
      %w(Error Killed Terminated).each do |state|
        fake_response = FakeResponse.new(taskState: state, taskErrors: { message: 'Blah' })
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
        expect { @client.wait_for('/rest/tasks/1') }.to raise_error(/ended with bad state[\S\s]*Blah/)
      end
    end
  end
end
