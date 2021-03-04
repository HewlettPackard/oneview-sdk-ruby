require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#version' do
    let(:command) { OneviewSDK::Cli.start(['version']) }

    it 'prints the gem version' do
      expect { command }.to output(/Gem Version:/).to_stdout_from_any_process
    end

    it 'prints the appliance version' do
      expect { command }.to output(/OneView appliance API version at .* = 2600/).to_stdout_from_any_process
    end

    it 'requires the url to be set' do
      ENV.delete('ONEVIEWSDK_URL')
      expect(STDOUT).to receive(:puts).with(/.*/)
      expect(STDOUT).to receive(:puts).with(/OneView appliance API version unknown/)
      command
    end
  end
end
