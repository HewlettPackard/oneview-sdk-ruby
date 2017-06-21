require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ConnectionTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::ConnectionTemplate' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::ConnectionTemplate
  end

  describe '#get_default' do
    it 'verify endpoint' do
      expect(@client_500).to receive(:rest_get).with('/rest/connection-templates/defaultConnectionTemplate').and_return(FakeResponse.new({}))
      connection = described_class.get_default(@client_500)
      expect(connection).to be_an_instance_of OneviewSDK::API500::Synergy::ConnectionTemplate
    end
  end
end
