require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#delete' do
    context 'with invalid options' do
      it 'requires a type' do
        expect { OneviewSDK::Cli.start(['delete']) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { OneviewSDK::Cli.start(%w(delete InvalidType name)) }.to raise_error SystemExit
      end

      it 'requires a resource name' do
        expect { OneviewSDK::Cli.start(%w(delete ServerProfiles)) }
          .to output(/was called with arguments.*\sUsage:/).to_stderr_from_any_process
      end
    end

    context 'with valid options' do
      before :each do
        @resource_data = { 'name' => 'Profile1', 'uri' => '/rest/fake', 'description' => 'Blah' }
        response = [OneviewSDK::ServerProfile.new(@client, @resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:delete).and_return(true)
        allow_any_instance_of(HighLine).to receive(:agree).and_return(true)
      end

      it 'deletes valid profiles' do
        expect_any_instance_of(HighLine).to receive(:agree)
        expect { OneviewSDK::Cli.start(%w(delete ServerProfile Profile1)) }
            .to output(/Deleted Successfully!/).to_stdout_from_any_process
      end

      it 'respects the force option' do
        expect_any_instance_of(HighLine).to_not receive(:agree)
        expect { OneviewSDK::Cli.start(%w(delete ServerProfile Profile1 -f)) }
            .to output(/Deleted Successfully!/).to_stdout_from_any_process
      end
    end

    context 'when the resource does not exist' do
      before :each do
        allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
        allow_any_instance_of(HighLine).to receive(:agree).and_return(true)
      end

      it 'prints a "Not Found" message' do
        expect(STDOUT).to receive(:puts).with(/Not Found/)
        expect { OneviewSDK::Cli.start(%w(delete ServerProfile FakeProfile)) }.to raise_error SystemExit
      end
    end
  end
end
