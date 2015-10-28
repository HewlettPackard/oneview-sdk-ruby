RSpec.shared_context 'shared context', a: :b do

  before :each do
    options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(options)
  end

end
