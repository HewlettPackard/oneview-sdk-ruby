require 'spec_helper'
require 'net/http/post/multipart'

RSpec.describe OneviewSDK::FirmwareBundle do
  include_context 'shared context'

  describe '#add' do
    it 'returns a FirmwareDriver resource' do
      options = { 'header' => { 'uploadfilename' => 'file.tar' } }
      expect(@client_300).to receive(:upload_file).with('file.tar', '/rest/firmware-bundles', options, OneviewSDK::Rest::READ_TIMEOUT).and_return({})
      expect(described_class.add(@client_300, 'file.tar').class).to eq(OneviewSDK::FirmwareDriver)
    end

    it 'should call client.upload_file correctly' do
      options = { 'header' => { 'uploadfilename' => 'file.tar' } }
      expect(@client_300).to receive(:upload_file).with('file.tar', '/rest/firmware-bundles', options, 100).and_return({})
      expect(described_class.add(@client_300, 'file.tar', 100).class).to eq(OneviewSDK::FirmwareDriver)
    end
  end
end
