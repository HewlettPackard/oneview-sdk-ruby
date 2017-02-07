require 'spec_helper'

klass = OneviewSDK::API300::Synergy::User
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'can delete resources' do
      item = klass.find_by($client, userName: USER_NAME).first
      item.retrieve!
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
