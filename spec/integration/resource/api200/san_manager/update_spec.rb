require 'spec_helper'

RSpec.describe OneviewSDK::SANManager, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:san_manager_ip) { $secrets['san_manager_ip'] }

  include_examples 'ConnectionInfoC7000'
  include_examples 'SANManagerUpdateExample', 'integration context'
end
