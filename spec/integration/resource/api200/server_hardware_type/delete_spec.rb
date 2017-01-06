require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  let(:server_hardware) do
    OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware2_ip']).first
  end
  subject(:target) { klass.find_by($client, uri: server_hardware['serverHardwareTypeUri']).first }

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

    context 'when no matches server hardware' do
      it 'should remove the resource' do
        expect { server_hardware.remove }.not_to raise_error
        expect { target.remove }.not_to raise_error
        expect(target.retrieve!).to eq(false)
      end
    end
  end
end
