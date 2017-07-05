require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::VolumeSnapshot do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::VolumeSnapshot' do
    expect(described_class).to be < OneviewSDK::API500::C7000::VolumeSnapshot
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      snapshot = described_class.new(@client_500)
      expect(snapshot.data).to_not include('type')
    end
  end
end
