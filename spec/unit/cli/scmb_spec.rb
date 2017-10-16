require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#scmb' do
    context 'with invalid options' do
      it 'requires a valid format' do
        expect($stderr).to receive(:puts).with(/Expected.+format/)
        described_class.start(%w[scmb -f InvalidFormat])
      end
    end

    let(:command) { OneviewSDK::Cli.start(%w[scmb]) }
    let(:command_eth) { OneviewSDK::Cli.start(%w[scmb -r scmb.ethernet-networks.#]) }
    let(:con) { double('connection') }
    let(:chan) { double('channel') }
    let(:queue) { double('queue') }
    let(:payload) { { resourceUri: '/rest/fake', changeType: 'Updated' } }


    before :each do
      allow(OneviewSDK::SCMB).to receive(:new_connection).and_return(con)
      allow(STDOUT).to receive(:puts).with(/Subscribing/)
    end

    it 'subscribes to the queue' do
      allow(OneviewSDK::SCMB).to receive(:new_queue) do |_c, route|
        expect(route).to eq(OneviewSDK::SCMB::DEFAULT_ROUTING_KEY)
        queue
      end
      allow(queue).to receive(:subscribe).and_return(true)
      command
    end

    it 'uses the routing key (-r) option' do
      allow(OneviewSDK::SCMB).to receive(:new_queue) do |_c, route|
        expect(route).to eq('scmb.ethernet-networks.#')
        queue
      end
      allow(queue).to receive(:subscribe).and_return(true)
      command_eth
    end

    context 'with output' do
      before :each do
        allow(OneviewSDK::SCMB).to receive(:new_queue) do |_c, route|
          expect(route).to eq('scmb.ethernet-networks.#')
          queue
        end
        allow(queue).to receive(:subscribe) do |_args, &block|
          block.yield(nil, nil, payload.to_json)
          true
        end
        expect(STDOUT).to receive(:puts).with(/Subscribing/)
        expect(STDOUT).to receive(:puts).with(/Received.+with.+payload:/)
      end

      it 'outputs the payload in json format by default' do
        expect(STDOUT).to receive(:puts).with(/#{JSON.pretty_generate(payload)}/)
        command_eth
      end

      it 'outputs the payload in raw format' do
        expect(STDOUT).to receive(:puts).with(/#{payload.to_json}/)
        OneviewSDK::Cli.start(%w[scmb -r scmb.ethernet-networks.# -f raw])
      end
    end
  end
end
