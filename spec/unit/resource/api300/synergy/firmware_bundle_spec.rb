require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::FirmwareBundle do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::FirmwareBundle
  end

  describe '#add' do
    it 'returns a FirmwareDriver resource' do
      options = { 'header' => { 'uploadfilename' => 'file.tar' } }
      expect(@client_300).to receive(:upload_file).with('file.tar', '/rest/firmware-bundles', options, OneviewSDK::Rest::READ_TIMEOUT).and_return({})
      expect(described_class.add(@client_300, 'file.tar').class).to eq(OneviewSDK::API300::Synergy::FirmwareDriver)
    end

    it 'should call client.upload_file correctly' do
      options = { 'header' => { 'uploadfilename' => 'file.tar' } }
      expect(@client_300).to receive(:upload_file).with('file.tar', '/rest/firmware-bundles', options, 100).and_return({})
      expect(described_class.add(@client_300, 'file.tar', 100).class).to eq(OneviewSDK::API300::Synergy::FirmwareDriver)
    end
  end
end
