require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  let(:server_hardware) do
    OneviewSDK::API300::Synergy::ServerHardware.get_all($client_300_synergy).first
  end
  subject(:target) { klass.find_by($client_300_synergy, uri: server_hardware['serverHardwareTypeUri']).first }

  describe '#delete' do
    it 'should throw unavailable exception' do
      expect { target.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    context 'when matches server hardware that is under management' do
      it 'should not remove the resource' do
        expect { target.remove }.to raise_error
        expect(target.retrieve!).to eq(true)
      end
    end
  end
end
