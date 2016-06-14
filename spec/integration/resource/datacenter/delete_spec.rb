require 'spec_helper'

RSpec.describe OneviewSDK::Datacenter, integration: true, type: DELETE, sequence: 9 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      datacenters = OneviewSDK::Datacenter.find_by($client, {})
      datacenters.each do |datacenter|
        datacenter.delete if [DATACENTER1_NAME, DATACENTER2_NAME, DATACENTER3_NAME].include?(datacenter['name'])
      end
      datacenter_after_deletion = OneviewSDK::Datacenter.find_by($client, {}).map { |datacenter| datacenter['name'] }
      [DATACENTER1_NAME, DATACENTER2_NAME, DATACENTER3_NAME].each { |name| expect(datacenter_after_deletion).not_to include(name) }
    end
  end
end
