RSpec.shared_context 'shared context', a: :b do

  before :each do
    options_120 = { url: 'https://16.125.106.34', user: 'Administrator', password: 'chefoneview', api_version: 120, ssl_enabled: false }
    options_200 = { url: 'https://16.125.106.34', user: 'Administrator', password: 'chefoneview', api_version: 200, ssl_enabled: false }

    if ENV['config_file']
      file = File.read(ENV['config_file'])
      options = JSON.parse(file)
      options_120 = options.clone
      options_200 = options.clone
      options_120[:api_version] = 120
      options_200[:api_version] = 200
      puts options_120
      puts options_200
    end
    @client_120 = OneviewSDK::Client.new(options_120)
    @client = OneviewSDK::Client.new(options_200)
  end

end

RSpec.shared_context 'cli context', a: :b do

  before :each do
    ENV['ONEVIEWSDK_URL'] = 'https://oneview.example.com'
    ENV['ONEVIEWSDK_USER'] = 'Admin'
    ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
  end

end
