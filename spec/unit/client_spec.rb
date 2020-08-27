require 'spec_helper'

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
      expect { OneviewSDK::Client.new(options) }.to raise_error(OneviewSDK::InvalidClient, /Must set user & password options or token/)
    end

    it 'requires the url attribute to be set' do
      expect { OneviewSDK::Client.new({}) }.to raise_error(OneviewSDK::InvalidClient, /Must set the url option/)
    end

    it 'sets the username to "Administrator" by default' do
      options = { url: 'https://oneview.example.com', password: 'secret123' }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/User option not set. Using default/).to_stdout_from_any_process
      expect(client.user).to eq('Administrator')
    end

    it 'sets the domain to "LOCAL" by default' do
      options = { url: 'https://oneview.example.com', token: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.domain).to eq('LOCAL')
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

    it 'respects the domain environment variable' do
      ENV['ONEVIEWSDK_DOMAIN'] = 'Other'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com', token: 'secret123')
      expect(client.domain).to eq('Other')
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
      options = { url: 'https://oneview.example.com', token: 'token123', api_version: 2000 }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/is greater than the appliance API version/).to_stdout_from_any_process
      expect(client.api_version).to eq(2000)
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

    it 'sets @timeout to nil by default' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.timeout).to be_nil
    end

    it 'allows @timeout to be set to true' do
      options = { url: 'https://oneview.example.com', token: 'token123', timeout: 5 }
      client = OneviewSDK::Client.new(options)
      expect(client.timeout).to eq(5)
    end

    it 'sets the module api version unless it has already been set' do
      expect(OneviewSDK).to receive(:api_version_updated?).and_return false
      expect(OneviewSDK).to receive(:api_version=).with(600).and_return true
      OneviewSDK::Client.new(url: 'https://oneview.example.com', token: 'token123', api_version: 600)
    end
  end

  describe 'attributes' do
    include_context 'shared context'

    it 'allows the url to be re-set' do
      @client_600.url = 'https://new-url.example.com'
      expect(@client_600.url).to eq('https://new-url.example.com')
    end

    it 'allows the user to be re-set' do
      @client_600.user = 'updatedUser'
      expect(@client_600.user).to eq('updatedUser')
    end

    it 'allows the password to be re-set' do
      @client_600.password = 'updatedPassword'
      expect(@client_600.password).to eq('updatedPassword')
    end

    it 'allows the token to be re-set' do
      @client_600.token = 'updatedToken'
      expect(@client_600.token).to eq('updatedToken')
    end

    it 'allows the log level to be re-set' do
      expect(@client_600.log_level).to_not eq(:error)
      @client_600.log_level = :error
      expect(@client_600.log_level).to eq(:error)
      expect(@client_600.logger.level).to eq(Logger.const_get(:ERROR))
    end

    it 'does not allow the max_api_version to be set manually' do
      expect { @client_600.max_api_version = 1 }.to raise_error(NoMethodError, /undefined method/)
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
      expect { client = OneviewSDK::Client.new(options) }.to output(/Failed to get OneView max api version. Using default/)
        .to_stdout_from_any_process
      expect(client.api_version).to eq(600)
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
      expect { OneviewSDK::Client.new(options) }.to raise_error(OneviewSDK::ConnectionError, /Couldn't log into OneView server/)
    end
  end

  describe 'resource action methods' do
    include_context 'shared context'

    before :each do
      @resource = OneviewSDK::Resource.new(@client_600)
    end

    it 'implements the #create method' do
      expect(@resource).to receive(:create)
      @client_600.create(@resource)
    end

    it 'implements the #update method' do
      expect(@resource).to receive(:update)
      @client_600.update(@resource, name: 'NewName')
    end

    it 'implements the #refresh method' do
      expect(@resource).to receive(:refresh)
      @client_600.refresh(@resource)
    end

    it 'implements the #delete method' do
      expect(@resource).to receive(:delete)
      @client_600.delete(@resource)
    end
  end

  describe '#get_all' do
    include_context 'shared context'

    it "calls the correct resource's get_all method" do
      expect(OneviewSDK::API600::C7000::ServerProfile).to receive(:get_all).with(@client_600)
      @client_600.get_all('ServerProfiles')
    end

    it 'accepts API version and variant parameters' do
      expect(OneviewSDK::API600::C7000::ServerProfile).to receive(:get_all).with(@client_600)
      @client_600.get_all('ServerProfiles', 600, 'C7000')
    end

    it 'accepts symbols instead of strings' do
      expect(OneviewSDK::API600::Synergy::ServerProfile).to receive(:get_all).with(@client_600)
      @client_600.get_all(:ServerProfiles, 600, :Synergy)
    end

    it 'fails when a bogus resource type is given' do
      expect { @client_600.get_all('BogusResources') }.to raise_error(TypeError, /Invalid resource type/)
    end

    it 'fails when a bogus API version is given' do
      expect { @client_600.get_all('ServerProfiles', 100) }.to raise_error(OneviewSDK::UnsupportedVersion, /version 100 is not supported/)
    end

    it 'fails when a bogus variant is given' do
      expect { @client_600.get_all('ServerProfiles', 600, 'Bogus') }.to raise_error(/variant 'Bogus' is not supported/)
    end
  end

  describe '#refresh_login' do
    include_context 'shared context'

    it 'refreshes the token and max_api_version' do
      expect(@client_600).to receive(:appliance_api_version).and_return(250)
      expect(@client_600).to receive(:login).and_return('newToken')
      @client_600.refresh_login
      expect(@client_600.max_api_version).to eq(250)
      expect(@client_600.token).to eq('newToken')
    end
  end

  describe '#destroy_session' do
    include_context 'shared context'

    it 'makes a REST call to destroy the session' do
      expect(@client_600).to receive(:rest_delete).with('/rest/login-sessions').and_return(FakeResponse.new)
      expect(@client_600.destroy_session).to eq(@client_600)
    end
  end

  describe '#wait_for' do
    include_context 'shared context'

    it 'requires a task_uri' do
      expect { @client_600.wait_for('') }.to raise_error(ArgumentError, /Must specify a task_uri/)
    end

    it 'returns the response body for completed tasks' do
      fake_response = FakeResponse.new(taskState: 'Completed', name: 'NewName')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
      ret = @client_600.wait_for('/rest/tasks/1')
      expect(ret).to eq('taskState' => 'Completed', 'name' => 'NewName')
    end

    it 'shows warnings' do
      fake_response = FakeResponse.new(taskState: 'Warning', taskErrors: 'Blah')
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
      ret = nil
      expect { ret = @client_600.wait_for('/rest/tasks/1') }.to output(/ended with warning.*Blah/).to_stdout_from_any_process
      expect(ret).to eq('taskState' => 'Warning', 'taskErrors' => 'Blah')
    end

    it 'raises an error if the task fails' do
      %w[Error Killed Terminated].each do |state|
        fake_response = FakeResponse.new(taskState: state, message: 'Blah')
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
        expect { @client_600.wait_for('/rest/tasks/1') }.to raise_error(OneviewSDK::TaskError, /ended with bad state[\S\s]*Blah/)
      end
    end

    it 'raises an error with the error details if the task fails' do
      %w[Error Killed Terminated].each do |state|
        fake_response = FakeResponse.new(taskState: state, taskErrors: { message: 'Blah' })
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(fake_response)
        expect { @client_600.wait_for('/rest/tasks/1') }.to raise_error(OneviewSDK::TaskError, /ended with bad state[\S\s]*Blah/)
      end
    end
  end

  describe '#new_i3s_client' do
    it 'creates a client i3s' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('token123')

      i3s_options = { url: 'https://imagestreamer.example.com' }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('token123')
    end

    it 'creates a client i3s with oneview client created by user and password' do
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('secretToken')

      i3s_options = { url: 'https://imagestreamer.example.com' }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('secretToken')
    end

    it 'creates a client i3s passing a token, but should use the oneview client' do
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('secretToken')

      i3s_options = { url: 'https://imagestreamer.example.com', token: 'token123' }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('secretToken')
    end

    it 'creates a client i3s passing the api version' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('token123')
      expect(client.api_version).to eq(600)

      i3s_options = { url: 'https://imagestreamer.example.com', api_version: 300 }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('token123')
      expect(i3s_client.api_version).to eq(300)
    end

    it 'creates an i3s client with oneview client and its specific version' do
      options = { url: 'https://oneview.example.com', token: 'token123', api_version: 300 }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('token123')
      expect(client.api_version).to eq(300)

      i3s_options = { url: 'https://imagestreamer.example.com', api_version: 300 }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('token123')
      expect(i3s_client.api_version).to eq(300)
    end

    it 'creates an i3s client with oneview client created with respects credential environment variables' do
      ENV['ONEVIEWSDK_USER'] = 'Admin'
      ENV['ONEVIEWSDK_PASSWORD'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.user).to eq('Admin')
      expect(client.password).to eq('secret456')
      expect(client.token).to eq('secretToken')

      i3s_options = { url: 'https://imagestreamer.example.com' }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('secretToken')
    end

    it 'creates an i3s client with oneview client created with respects the token environment variable' do
      ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.token).to eq('secret456')

      i3s_options = { url: 'https://imagestreamer.example.com' }
      i3s_client = client.new_i3s_client(i3s_options)
      expect(i3s_client.url).to eq('https://imagestreamer.example.com')
      expect(i3s_client.token).to eq('secret456')
    end
  end
end
