require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::LogicalEnclosure, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#patch' do
    it 'Update a given logical enclosure' do

      retrieved_item = OneviewSDK::API300::C7000::
      LogicalEnclosure.find_by($client_300, name: ENCL_NAME).first

      to_update = [{
        op: 'replace',
        path: '/firmware',
        value: {
          firmwareUpdateOn: 'SharedInfrastructureOnly',
          forceInstallFirmware: false,
          updateFirmwareOnUnmanagedInterconnect: true
        }
      }]
      expect { retrieved_item.patch($client_300, to_update) }.to_not raise_error
    end
  end
end
