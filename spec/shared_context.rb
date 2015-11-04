RSpec.shared_context 'shared context', a: :b do

  before :each do
    options_120 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 120 }
    @client_120 = OneviewSDK::Client.new(options_120)

    options_200 = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(options_200)
  end

end
