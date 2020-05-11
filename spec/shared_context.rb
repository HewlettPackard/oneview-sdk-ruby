# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    # Creates dynamically the variables @client_120, @client_200 and etc.
    api_versions = [120]
    api_versions |= OneviewSDK::SUPPORTED_API_VERSIONS
    api_versions.each do |v|
      instance_variable_set("@client_#{v}", OneviewSDK::Client.new(options.merge(api_version: v)))
    end

    options_i3s = { url: 'https://oneview.example.com', token: 'token123' }
    # Creates dynamically the variables @client_i3s_300 and etc.
    i3s_api_versions = OneviewSDK::ImageStreamer::SUPPORTED_API_VERSIONS
    i3s_api_versions.each do |v|
      instance_variable_set("@client_i3s_#{v}", OneviewSDK::ImageStreamer::Client.new(options_i3s.merge(api_version: v)))
    end
  end
end

# Context for CLI testing:
RSpec.shared_context 'cli context', a: :b do
  before :each do
    ENV['ONEVIEWSDK_URL'] = 'https://oneview.example.com'
    ENV['ONEVIEWSDK_USER'] = 'Admin'
    ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
    ENV['I3S_URL'] = 'https://i3s.example.com'
  end
end

# Context for API =< 200 integration testing:
# WARNING: Communicates with & modifies a real instance.
RSpec.shared_context 'integration context', a: :b do
  before :all do
    integration_context
    $client_120 ||= OneviewSDK::Client.new($config.merge(api_version: 120))
    $client     ||= OneviewSDK::Client.new($config.merge(api_version: 200))
  end
end

# Context for API300 integration testing:
RSpec.shared_context 'integration api300 context', a: :b do
  before :all do
    integration_context
    $client_300 ||= OneviewSDK::Client.new($config.merge(api_version: 300))
    $client_300_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 300))
  end
end

# Context for API500 integration testing:
RSpec.shared_context 'integration api500 context', a: :b do
  before :all do
    integration_context
    $client_500 ||= OneviewSDK::Client.new($config.merge(api_version: 500))
    $client_500_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 500))
  end
end

# Context for API600 integration testing:
RSpec.shared_context 'integration api600 context', a: :b do
  before :all do
    integration_context
    $client_600 ||= OneviewSDK::Client.new($config.merge(api_version: 600))
    $client_600_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 600))
  end
end

# Context for API800 integration testing:
RSpec.shared_context 'integration api800 context', a: :b do
  before :all do
    integration_context
    $client_800 ||= OneviewSDK::Client.new($config.merge(api_version: 800))
    $client_800_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 800))
  end
end

# Context for API1000 integration testing:
RSpec.shared_context 'integration api1000 context', a: :b do
  before :all do
    integration_context
    $client_1000 ||= OneviewSDK::Client.new($config.merge(api_version: 1000))
    $client_1000_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 1000))
  end
end

# Context for API1200 integration testing:
RSpec.shared_context 'integration api1200 context', a: :b do
  before :all do
    integration_context
    $client_1200 ||= OneviewSDK::Client.new($config.merge(api_version: 1200))
    $client_1200_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 1200))
  end
end

# Context for API1600 integration testing:
RSpec.shared_context 'integration api1600 context', a: :b do
  before :all do
    integration_context
    $client_1600 ||= OneviewSDK::Client.new($config.merge(api_version: 1600))
    $client_1600_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 1600))
  end
end

# Context for Image Streamer API300 integration testing:
RSpec.shared_context 'integration i3s api300 context', a: :b do
  before :all do
    integration_context
    integration_context_i3s
    oneview_client ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 300))
    $client_i3s_300 ||= oneview_client.new_i3s_client($config_i3s.merge(api_version: 300))
  end
end

# Context for Image Streamer API500 integration testing:
RSpec.shared_context 'integration i3s api500 context', a: :b do
  before :all do
    integration_context
    integration_context_i3s
    oneview_client ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 500))
    $client_i3s_500 ||= oneview_client.new_i3s_client($config_i3s.merge(api_version: 500))
  end
end

# Context for Image Streamer API600 integration testing:
RSpec.shared_context 'integration i3s api600 context', a: :b do
  before :all do
    integration_context
    integration_context_i3s
    oneview_client ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 600))
    $client_i3s_600 ||= oneview_client.new_i3s_client($config_i3s.merge(api_version: 600))
  end
end

RSpec.shared_context 'system context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(200)
  end
end

RSpec.shared_context 'system api300 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(300)
  end
end

RSpec.shared_context 'system api500 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(500)
  end
end

RSpec.shared_context 'system api600 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(600)
  end
end

RSpec.shared_context 'system api800 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(800)
  end
end

RSpec.shared_context 'system api1000 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(1000)
  end
end

RSpec.shared_context 'system api1200 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(1200)
  end
end

RSpec.shared_context 'system api1600 context', a: :b do
  before(:each) do
    load_system_properties
    generate_clients(1600)
  end
end

# Must set the following environment variables:
#   ENV['ONEVIEWSDK_INTEGRATION_CONFIG'] = '/full/path/to/one_view/config.json'
#   ENV['ONEVIEWSDK_INTEGRATION_SECRETS'] = '/full/path/to/one_view/secrets.json'
# Or use the default paths:
#   spec/integration/one_view_config.json
#   spec/integration/one_view_secrets.json
def integration_context
  default_config = 'spec/integration/one_view_config.json'
  default_config_synergy = 'spec/integration/one_view_synergy_config.json'
  default_secrets = 'spec/integration/one_view_secrets.json'
  default_secrets_synergy = 'spec/integration/one_view_synergy_secrets.json'
  @config_path ||= ENV['ONEVIEWSDK_INTEGRATION_CONFIG'] || default_config
  @config_path_synergy ||= ENV['ONEVIEWSDK_INTEGRATION_CONFIG_SYNERGY'] || default_config_synergy
  @secrets_path ||= ENV['ONEVIEWSDK_INTEGRATION_SECRETS'] || default_secrets
  @secrets_path_synergy ||= ENV['ONEVIEWSDK_INTEGRATION_SECRETS_SYNERGY'] || default_secrets_synergy

  # Ensure config & secrets files exist
  unless File.file?(@config_path) && File.file?(@secrets_path)
    STDERR.puts "\n\n"
    STDERR.puts 'ERROR: Integration config file not found' unless File.file?(@config_path)
    STDERR.puts 'ERROR: Integration secrets file not found' unless File.file?(@secrets_path)
    STDERR.puts "\n\n"
    exit!
  end
  $secrets ||= OneviewSDK::Config.load(@secrets_path) # Secrets for URIs, server/enclosure credentials, etc.
  $secrets_synergy ||= OneviewSDK::Config.load(@secrets_path_synergy) # Secrets for URIs, server/enclosure credentials, etc.
  # Creates the global config variable
  $config ||= OneviewSDK::Config.load(@config_path)
  $config_synergy ||= OneviewSDK::Config.load(@config_path_synergy)
end

# Must set the following environment variables:
#   ENV['I3S_INTEGRATION_CONFIG'] = '/full/path/to/i3s/config.json'
# Or use the default paths:
#   spec/integration/i3s_config.json
def integration_context_i3s
  default_config = 'spec/integration/i3s_config.json'
  @config_path_i3s ||= ENV['I3S_INTEGRATION_CONFIG'] || default_config
  # Ensure config & secrets files exist
  unless File.file?(@config_path_i3s)
    STDERR.puts "\n\n"
    STDERR.puts 'ERROR: Integration config i3s file not found' unless File.file?(@config_path_i3s)
    STDERR.puts "\n\n"
    exit!
  end

  # Creates the global config variable
  $config_i3s ||= OneviewSDK::Config.load(@config_path_i3s)
end

# Must set the following environment variables:
#   ENV['ONEVIEWSDK_SYSTEM_CONFIG'] = '/full/path/to/one_view/one_view_config.json'
#   ENV['ONEVIEWSDK_SYSTEM_SECRETS'] = '/full/path/to/one_view/one_view_secrets.json'
#   ENV['ONEVIEWSDK_SYSTEM_CONFIG_SYNERGY'] = '/full/path/to/one_view/one_view_config_synergy.json'
#   ENV['ONEVIEWSDK_SYSTEM_SECRETS_SYNERGY'] = '/full/path/to/one_view/one_view_secrets_synergy.json'
# Or use the default paths:
#   spec/system/one_view_config.json
#   spec/system/one_view_secrets.json
#   spec/system/one_view_config_synergy.json
#   spec/system/one_view_secrets_synergy.json
def load_system_properties
  default_config  = 'spec/system/one_view_config.json'
  default_secrets = 'spec/system/one_view_secrets.json'
  default_config_synergy  = 'spec/system/one_view_config_synergy.json'
  default_secrets_synergy = 'spec/system/one_view_secrets_synergy.json'

  @config_path  ||= ENV['ONEVIEWSDK_SYSTEM_CONFIG']  || default_config
  @secrets_path ||= ENV['ONEVIEWSDK_SYSTEM_SECRETS'] || default_secrets
  @config_path_synergy  ||= ENV['ONEVIEWSDK_SYSTEM_CONFIG_SYNERGY']  || default_config_synergy
  @secrets_path_synergy ||= ENV['ONEVIEWSDK_SYSTEM_SECRETS_SYNERGY'] || default_secrets_synergy

  unless File.file?(@config_path) && File.file?(@secrets_path)
    STDERR.puts "\n\n"
    STDERR.puts 'ERROR: System config file not found' unless File.file?(@config_path)
    STDERR.puts 'ERROR: System secrets file not found' unless File.file?(@secrets_path)
    STDERR.puts "\n\n"
    exit!
  end

  unless File.file?(@config_path_synergy) && File.file?(@secrets_path_synergy)
    STDERR.puts "\n\n"
    STDERR.puts 'ERROR: System config file for Synergy not found' unless File.file?(@config_path_synergy)
    STDERR.puts 'ERROR: System secrets file for Synergy not found' unless File.file?(@secrets_path_synergy)
    STDERR.puts "\n\n"
    exit!
  end

  $secrets ||= OneviewSDK::Config.load(@secrets_path) # Secrets for URIs, server/enclosure credentials, etc.
  $secrets_synergy ||= OneviewSDK::Config.load(@secrets_path_synergy) # Secrets for URIs, server/enclosure credentials, etc.
end

# Create client objects:
# @param [Integer] api_version Integer representing the api version of the Oneview
def generate_clients(api_version)
  $config ||= OneviewSDK::Config.load(@config_path)
  $config_synergy ||= OneviewSDK::Config.load(@config_path_synergy) if api_version >= 300

  case api_version
  when 200
    $client_120 ||= OneviewSDK::Client.new($config.merge(api_version: 120))
    $client ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
  when 300
    $client_300 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_300_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 500
    $client_500 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_500_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 600
    $client_600 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_600_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 800
    $client_800 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_800_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 1000
    $client_1000 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_1000_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 1200
    $client_1200 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_1200_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  when 1600
    $client_1600 ||= OneviewSDK::Client.new($config.merge(api_version: api_version))
    $client_1600_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: api_version))
  end

  allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_call_original
  allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_call_original
end
