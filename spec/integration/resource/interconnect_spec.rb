require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect, integration: true do
  include_context 'integration context'

  let(:interconnect) { OneviewSDK::Interconnect.find_by(@client, {}).last }

  describe '#nameServers' do
    it 'Retrieve name servers' do
      expect { interconnect.nameServers }.not_to raise_error
    end
  end

  describe '#resetportprotection' do
    it 'valid' do
      expect { interconnect.resetportprotection }.not_to raise_error
    end
  end

  describe '#update_port' do
    it 'Updating valid attribute' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], enabled: !port['enabled']) }.not_to raise_error
    end

    it 'Updating valid attribute' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], none: 'none') }.to raise_error
    end
  end


  describe '#statistics' do
    it 'interconnect statistics' do
      expect { interconnect.statistics }.not_to raise_error
    end
    it 'interconnect port statistics' do
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

  describe '#updateAttribute' do
  end

end
