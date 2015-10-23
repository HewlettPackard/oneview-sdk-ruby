require 'pry'
require 'simplecov'
SimpleCov.start

require 'oneview-sdk-ruby'

RSpec.configure do |config|
  config.before(:each) do
    # TODO
  end

end

# OneView::Config[:log_level] = :warn
