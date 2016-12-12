require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::UnmanagedDevice
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'should throw unavailable exception' do
      item = klass.new($client_300, name: UNMANAGED_DEVICE1_NAME)
      item.retrieve!
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    it 'remove resource' do
      item = klass.new($client_300, name: UNMANAGED_DEVICE1_NAME)
      item.retrieve!
      expect { item.remove }.to_not raise_error
    end
  end
end
