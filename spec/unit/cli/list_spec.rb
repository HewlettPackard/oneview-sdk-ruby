require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#list' do
    context 'with invalid options' do
      it 'requires a type' do
        expect { OneviewSDK::Cli.start(['list']) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { OneviewSDK::Cli.start(%w(list InvalidType)) }.to raise_error SystemExit
      end
    end

    let(:command) { OneviewSDK::Cli.start(%w(list ServerProfiles)) }

    before :each do
      response = [{ name: 'Profile1' }, { name: 'Profile2' }, { name: 'Profile3' }]
      allow(OneviewSDK::BaseResource).to receive(:find_by).and_return(response)
    end

    it 'prints a list of resource names' do
      expect(OneviewSDK::BaseResource).to receive(:find_by).with(OneviewSDK::Client, {})
      expect { command }.to output(/Profile1\sProfile2\sProfile3\s/).to_stdout_from_any_process
    end

    it 'prints a resource count total at the end' do
      expect { command }.to output(/\n\nTotal: 3$/).to_stdout_from_any_process
    end

  end
end
