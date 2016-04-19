require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:interconnect) { OneviewSDK::Interconnect.find_by($client, {}).last }

  describe '#name_servers' do
    it 'retrieves name servers' do
      expect { interconnect.name_servers }.not_to raise_error
    end
  end

  describe '#resetportprotection' do
    it 'triggers a reset of port protection' do
      expect { interconnect.reset_port_protection }.not_to raise_error
    end
  end

  describe '#update_port' do
    it 'updates with valid attributes' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], enabled: !port['enabled']) }.not_to raise_error
    end

    it 'fails to update with invalid attributes' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], none: 'none') }.to raise_error(/BAD REQUEST/)
    end
  end

  describe '#statistics' do
    it 'gets statistics' do
      expect { interconnect.statistics }.not_to raise_error
    end
    it 'gets statistics for a specific port' do
      port = interconnect[:ports].first
      expect { interconnect.statistics(port['name']) }.not_to raise_error
    end

    # Missing example with subport
    it 'interconnect subport statistics' do
      port = interconnect[:ports].first
      subport = nil
      expect { interconnect.statistics(port['name'], subport) }.not_to raise_error
    end
  end

  describe '#update_attribute' do
    it 'is a pending example'
  end
end
