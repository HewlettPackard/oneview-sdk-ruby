require 'spec_helper'

RSpec.describe OneviewSDK::LogicalEnclosure, integration: true do
  include_context 'integration context'

  describe '#configuration' do
    it 'Reconfigure logical enclosure' do
      item = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
      expect { item.reconfigure }.to_not raise_error
    end
  end

  describe '#updateFromGroup' do
    it 'Update logical enclosure from group' do
      item = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
      expect { item.update_from_group }.to_not raise_error
    end
  end

  describe '#script' do
    it 'Change script and validate' do
      item = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
      expect { item.set_script('#TEST') }.to_not raise_error
      expect(item.get_script.tr('"', '')).to eq('#TEST')
    end
  end

  describe '#support_dump' do
    it 'Support dump' do
      item = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
      expect { item.support_dump(errorCode: 'teste') }.to_not raise_error
    end
  end

end
