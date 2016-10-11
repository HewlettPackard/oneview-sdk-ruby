require 'spec_helper'

klass = OneviewSDK::EnclosureGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the simple enclosure group' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP_NAME)
      item.retrieve!
      expect { @item.delete }.not_to raise_error
    end

    it 'deletes the enclosure group with LIG' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP2_NAME)
      item.retrieve!
      expect { @item.delete }.not_to raise_error
    end

    it 'deletes the enclosure group with empty LIG' do
      item = OneviewSDK::EnclosureGroup.new($client, 'name' => ENC_GROUP3_NAME)
      item.retrieve!
      expect { @item.delete }.not_to raise_error
    end
  end
end
