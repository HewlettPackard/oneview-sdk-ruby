# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options_120 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 120 }
    @client_120 = OneviewSDK::Client.new(options_120)

    options_200 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(options_200)

    options_300 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 300 }
    @client_300 = OneviewSDK::Client.new(options_300)
  end
end

# Context for CLI testing:
RSpec.shared_context 'cli context', a: :b do
  before :each do
    ENV['ONEVIEWSDK_URL'] = 'https://oneview.example.com'
    ENV['ONEVIEWSDK_USER'] = 'Admin'
    ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
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

  integration_context_debugging
end

# Context for API300 integration testing:
RSpec.shared_context 'integration api300 context', a: :b do
  before :all do
    integration_context
    $client_300 ||= OneviewSDK::Client.new($config.merge(api_version: 300))
    $client_300_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 300))
  end

  integration_context_debugging
end

RSpec.shared_context 'system context', a: :b do

  before(:each) do
    system_context
    $client_120 ||= OneviewSDK::Client.new($config.merge(api_version: 120))
    $client     ||= OneviewSDK::Client.new($config.merge(api_version: 200))

    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_call_original
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_call_original
  end

end

RSpec.shared_context 'system api300 context', a: :b do

  before(:each) do
    system_context
    $client_300 ||= OneviewSDK::Client.new($config.merge(api_version: 300))
    $client_300_synergy ||= OneviewSDK::Client.new($config_synergy.merge(api_version: 300))

    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_call_original
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_call_original
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

# For debugging only: Shows test metadata without actually running the tests
def integration_context_debugging
  before :each do |e|
    if ENV['PRINT_METADATA_ONLY']
      action = case e.metadata[:type]
               when CREATE then 'CREATE'
               when UPDATE then 'UPDATE'
               when DELETE then 'DELETE'
               else '_____'
               end
      puts "#{action} #{e.metadata[:sequence] || '_'}: #{described_class}: #{e.metadata[:description]}"
      raise 'Skipped'
    end
  end
end

def system_context
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

  $secrets ||= OneviewSDK::Config.load(@secrets_path) # Secrets for URIs, server/enclosure credentials, etc.
  $secrets_synergy ||= OneviewSDK::Config.load(@secrets_path_synergy) # Secrets for URIs, server/enclosure credentials, etc.

  # Create client objects:
  $config ||= OneviewSDK::Config.load(@config_path)
  $config_synergy ||= OneviewSDK::Config.load(@config_path_synergy)
end
