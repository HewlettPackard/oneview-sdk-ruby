require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#search' do

    let(:resource_data) do
      { 'name' => 'Profile1', 'uri' => '/rest/fake', 'description' => 'Blah' }
    end

    let(:resource_data2) do
      { 'name' => 'Profile2', 'uri' => '/rest/fake2', 'description' => 'Blah' }
    end

    let(:response) do
      [
        OneviewSDK::ServerProfile.new(@client, resource_data),
        OneviewSDK::ServerProfile.new(@client, resource_data2)
      ]
    end

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
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
      end

      it 'prints the list of resource names' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'Blah')
        out = [resource_data['name'], resource_data2['name']]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:Blah)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end

      it 'prints a subset of the resource details when the attribute option is given' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'Blah')
        out = [{ resource_data['name'] => { 'uri' => resource_data['uri'] } }, { resource_data2['name'] => { 'uri' => resource_data2['uri'] } }]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:Blah -a uri)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end

      it 'allows attribute chaining' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'key1' => { 'key2' => { 'key3' => 'Blah' } })
        out = [resource_data['name'], resource_data2['name']]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter key1.key2.key3:Blah)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end
    end

    context 'with filter that needs to be parsed' do
      it 'parses booleans' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'false').and_return []
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => false).and_return response
        out = [resource_data['name'], resource_data2['name']]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:false)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end

      it 'parses integers' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => '10').and_return []
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 10).and_return response
        out = [resource_data['name'], resource_data2['name']]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:10)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end

      it 'parses nil' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => 'nil').and_return []
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, 'description' => nil).and_return response
        out = [resource_data['name'], resource_data2['name']]
        expect { OneviewSDK::Cli.start(%w(search ServerProfile -f yaml --filter description:nil)) }
          .to output(out.to_yaml).to_stdout_from_any_process
      end
    end

  end
end
