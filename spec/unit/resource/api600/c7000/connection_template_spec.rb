require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ConnectionTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::ConnectionTemplate' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ConnectionTemplate
  end

  describe '#get_default' do
    it 'verify endpoint' do
      expect(@client_600).to receive(:rest_get).with('/rest/connection-templates/defaultConnectionTemplate').and_return(FakeResponse.new({}))
      connection = described_class.get_default(@client_600)
      expect(connection).to be_an_instance_of OneviewSDK::API600::C7000::ConnectionTemplate
    end
  end
end
