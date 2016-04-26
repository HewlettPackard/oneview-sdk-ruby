require 'spec_helper'

RSpec.describe OneviewSDK::UplinkSet, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    before :each do
      @interconnect = OneviewSDK::Interconnect.get_all($client).last # TODO: Find a more specific one?
      @enclosure = OneviewSDK::Enclosure.find_by($client, name: ENCL_NAME).first
    end

    it 'update portConfigInfos' do
      uplink = OneviewSDK::UplinkSet.new($client, name: UPLINK_SET_NAME)
      expect { uplink.retrieve! }.not_to raise_error
      uplink.add_port_config(
        @interconnect[:uri],
        'Auto',
        [{ value: 1, type: 'Bay' }, { value: @enclosure[:uri], type: 'Enclosure' }, { value: 'X7', type: 'Port' }]
      )
      expect { uplink.update }.not_to raise_error
    end
  end
end
