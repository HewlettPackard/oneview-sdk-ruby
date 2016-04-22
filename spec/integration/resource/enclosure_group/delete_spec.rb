require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true, type: DELETE, sequence: 10 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the simple enclosure group' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP_NAME)
      item.retrieve!
      item.delete
    end

    it 'deletes the enclosure group with LIG' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP2_NAME)
      item.retrieve!
      item.delete
    end

    it 'deletes the enclosure group with empty LIG' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP3_NAME)
      item.retrieve!
      item.delete
    end
  end
end
