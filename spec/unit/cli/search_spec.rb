require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#search' do

    context 'with invalid options' do
      it 'requires a type' do
        expect { OneviewSDK::Cli.start(%w(search --filter='name:Profile1')) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { OneviewSDK::Cli.start(%w(search InvalidType --filter name:Profile1)) }.to raise_error SystemExit
      end

      it 'requires a filter' do
        expect { OneviewSDK::Cli.start(%w(search ServerProfiles)) }
          .to output(/No value provided for required options '--filter'/).to_stderr_from_any_process
      end
    end

    context 'with filter' do
      before :each do
        @resource_data = { 'name' => 'Profile1', 'uri' => '/rest/fake', 'description' => 'Blah' }
        @resource_data2 = { 'name' => 'Profile2', 'uri' => '/rest/fake2', 'description' => 'Blah' }
        response = [
          OneviewSDK::ServerProfile.new(@client, @resource_data),
          OneviewSDK::ServerProfile.new(@client, @resource_data2)
        ]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
      end

      it 'prints the resource details' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'Blah')
        out = [@resource_data.merge('type' => 'ServerProfileV5'), @resource_data2.merge('type' => 'ServerProfileV5')]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:Blah)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end

      it 'prints a subset of the resource details when the attribute option is given' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'Blah')
        out = [@resource_data.select { |k, _v| k == 'uri' }, @resource_data2.select { |k, _v| k == 'uri' }]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:Blah -a uri)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end
    end

  end
end
