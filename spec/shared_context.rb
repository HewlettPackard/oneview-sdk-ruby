# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options_120 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 120 }
    @client_120 = OneviewSDK::Client.new(options_120)

    options_200 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(options_200)
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

# Context for integration testing:
# WARNING: Communicates with & modifies a real instance.
# Must set the following environment variables:
#   ENV['ONEVIEWSDK_INTEGRATION_CONFIG'] = '/full/path/to/one_view/config.json'
#   ENV['ONEVIEWSDK_INTEGRATION_SECRETS'] = '/full/path/to/one_view/secrets.json'
# Or use the default paths:
#   spec/integration/one_view_config.json
#   spec/integration/one_view_secrets.json
RSpec.shared_context 'integration context', a: :b do
  # Ensure config & secrets files exist
  before :all do
    default_config  = 'spec/integration/one_view_config.json'
    default_secrets = 'spec/integration/one_view_secrets.json'

    @config_path  ||= ENV['ONEVIEWSDK_INTEGRATION_CONFIG']  || default_config
    @secrets_path ||= ENV['ONEVIEWSDK_INTEGRATION_SECRETS'] || default_secrets

    unless File.file?(@config_path) && File.file?(@secrets_path)
      STDERR.puts "\n\n"
      STDERR.puts 'ERROR: Integration config file not found' unless File.file?(@config_path)
      STDERR.puts 'ERROR: Integration secrets file not found' unless File.file?(@secrets_path)
      STDERR.puts "\n\n"
      exit!
    end

    $secrets ||= OneviewSDK::Config.load(@secrets_path) # Secrets for URIs, server/enclosure credentials, etc.

    # Create client objects:
    $config  ||= OneviewSDK::Config.load(@config_path)
    $client_120 ||= OneviewSDK::Client.new($config.merge(api_version: 120))
    $client     ||= OneviewSDK::Client.new($config.merge(api_version: 200))
  end

  before :each do |e| # For debugging only: Shows test metadata
    action = case e.metadata[:type]
             when CREATE then 'CREATE'
             when UPDATE then 'UPDATE'
             when DELETE then 'DELETE'
             else '_____'
             end
    puts "#{action} #{e.metadata[:sequence] || '_'}: #{described_class}: #{e.metadata[:description]}"
    # fail 'Skipped' # Un-comment to skip running the tests
  end
end
