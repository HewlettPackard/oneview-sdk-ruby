require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::FirmwareBundle do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::FirmwareBundle
  end

  describe '#add' do
    it 'fails if the file does not exist' do
      expect { described_class.add(@client_300, 'file.fake') }.to raise_error(OneviewSDK::NotFound, //)
    end

    it 'returns a FirmwareDriver resource' do
      expect(@client_300).to receive(:rest_post).with(
        OneviewSDK::API300::Thunderbird::FirmwareBundle::BASE_URI,
        hash_including(
          'body' => %r{Content-Type: application/octet-stream; Content-Transfer-Encoding: binary\r\n\r\nFAKE FILE CONTENT\r\n--},
          'uploadfilename' => 'file.tar',
          'Content-Type' => "multipart/form-data; boundary=#{OneviewSDK::API300::Thunderbird::FirmwareBundle::BOUNDARY}"
        )
      ).and_return(FakeResponse.new({}))
      expect(File).to receive('file?').and_return(true)
      allow(IO).to receive(:binread).and_return('FAKE FILE CONTENT')
      OneviewSDK::API300::Thunderbird::FirmwareBundle.add(@client_300, 'file.tar')
    end
  end
end
