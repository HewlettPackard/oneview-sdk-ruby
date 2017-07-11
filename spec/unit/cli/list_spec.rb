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

      it 'requires a valid variant' do
        expect { OneviewSDK::Cli.start(%w(list ServerProfiles --variant Invalid)) }
          .to output(/Expected '--variant' to be one of/).to_stderr_from_any_process
      end

      it 'requires a valid variant ENV variable' do
        ENV['ONEVIEWSDK_VARIANT'] = 'Invalid'
        expect(STDOUT).to receive(:puts).with(/Variant 'Invalid' is not supported/)
        expect { OneviewSDK::Cli.start(%w(list ServerProfiles)) }.to raise_error SystemExit
      end
    end

    let(:command) { OneviewSDK::Cli.start(%w(list ServerProfiles)) }

    before :each do
      @response = [{ name: 'Profile1' }, { name: 'Profile2' }, { name: 'Profile3' }]
      allow(OneviewSDK::Resource).to receive(:find_by).and_return(@response)
    end

    it 'prints a list of resource names' do
      expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, {}, OneviewSDK::ServerProfile::BASE_URI, {})
      expect { command }.to output(/Profile1\sProfile2\sProfile3\s/).to_stdout_from_any_process
    end

    it 'prints a resource count total at the end' do
      expect { command }.to output(/\n\nTotal: 3$/).to_stdout_from_any_process
    end

    it 'sets the client api version if passed in as a param' do
      allow(OneviewSDK::Client).to receive(:find_by).with(hash_including('api_version' => 201)).and_call_original
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 201)) }
        .to output.to_stdout_from_any_process
    end

    it "sets the client api version if ENV['ONEVIEWSDK_API_VERSION'] is set" do
      ENV['ONEVIEWSDK_API_VERSION'] = '201'
      allow(OneviewSDK::Client).to receive(:find_by).with(hash_including('api_version' => 201)).and_call_original
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 201)) }
        .to output.to_stdout_from_any_process
    end

    it 'checks for a valid module api version' do
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 291)) }
        .to output(/API version 291 is not supported. Using 200+\sProfile1/).to_stdout_from_any_process
    end

    it 'rounds an invalid module api version down' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(400)
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 399)) }
        .to output(/API version 399 is not supported. Using 300+\sProfile1/).to_stdout_from_any_process
    end

    it 'rounds an invalid module api version up if cannot round down' do
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 0)) }
        .to output(/API version 0 is not supported. Using 200+\sProfile1/).to_stdout_from_any_process
    end

    it 'handles a float type api version' do
      allow(OneviewSDK::Client).to receive(:find_by).with(hash_including('api_version' => 2)).and_call_original
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 2.01)) }
        .to output(/API version 2 is not supported. Using \d+\sProfile1/).to_stdout_from_any_process
    end

    it 'uses the api-version & variant params when looking for an API module' do
      expect(OneviewSDK::API300::Synergy::ServerProfile).to receive(:get_all).and_return(@response)
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles --api_version 300 --variant Synergy)) }
        .to output.to_stdout_from_any_process
    end

    it 'uses the ONEVIEWSDK_API_VERSION & ONEVIEWSDK_VARIANT environment variables' do
      ENV['ONEVIEWSDK_API_VERSION'] = '300'
      ENV['ONEVIEWSDK_VARIANT'] = 'Synergy'
      expect(OneviewSDK::API300::Synergy::ServerProfile).to receive(:get_all).and_return(@response)
      expect { OneviewSDK::Cli.start(%w(list ServerProfiles)) }
        .to output.to_stdout_from_any_process
    end
  end
end
