require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  let(:data) { { 'key1' => 'val1', 'key2' => 'val2' } }
  let(:response) { { 'key1' => 'val1', 'key2' => 'val2', 'key3' => { 'key4' => 'val4' } } }

  describe '#rest get' do
    it 'requires a URI' do
      expect($stderr).to receive(:puts).with(/ERROR.*arguments/)
      described_class.start(%w(rest get))
    end

    it 'sends any data that is passed in' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
        .with('get', '/rest/fake', body: data).and_return FakeResponse.new(response)
      expect { described_class.start(['rest', 'get', 'rest/fake', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end

    context 'output formats' do
      before :each do
        expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
          .with('get', '/rest/fake', {}).and_return FakeResponse.new(response)
      end

      it 'makes a GET call to the URI and outputs the response in json format' do
        expect { described_class.start(%w(rest get rest/fake)) }
          .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
      end

      it 'can output the response in raw format' do
        expect { described_class.start(%w(rest get rest/fake -f raw)) }
          .to output(response.to_json + "\n").to_stdout_from_any_process
      end

      it 'can output the response in yaml format' do
        expect { described_class.start(%w(rest get rest/fake -f yaml)) }
          .to output(response.to_yaml).to_stdout_from_any_process
      end
    end

    context 'bad requests' do
      it 'fails if the data cannot be parsed as json' do
        expect($stdout).to receive(:puts).with(/Failed to parse data as JSON/)
        expect { described_class.start(%w(rest get rest/ -d fake_json)) }
          .to raise_error SystemExit
      end

      it 'fails if the request method is invalid' do
        expect($stdout).to receive(:puts).with(/Invalid rest method/)
        expect { described_class.start(%w(rest blah rest/)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 3XX' do
        headers = { 'location' => ['rest/Systems/1/'] }
        body = {}
        expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
          .with('get', '/rest', {}).and_return FakeResponse.new(body, 308, headers)
        expect($stdout).to receive(:puts).with(/308.*location/m)
        expect { described_class.start(%w(rest get rest)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 4XX' do
        headers = { 'content-type' => ['text/plain'] }
        body = { 'Message' => 'Not found!' }
        expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
          .with('get', '/rest', {}).and_return FakeResponse.new(body, 404, headers)
        expect($stdout).to receive(:puts).with(/404.*content-type.*Not found/m)
        expect { described_class.start(%w(rest get rest)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 4XX' do
        headers = { 'content-type' => ['text/plain'] }
        body = { 'Message' => 'Server error!' }
        expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
          .with('get', '/rest', {}).and_return FakeResponse.new(body, 500, headers)
        expect($stdout).to receive(:puts).with(/500.*content-type.*Server error/m)
        expect { described_class.start(%w(rest get rest)) }
          .to raise_error SystemExit
      end
    end
  end

  describe '#rest post' do
    it 'makes a rest call with any data that is passed in' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
        .with('post', '/rest/fake', body: data).and_return FakeResponse.new(response)
      expect { described_class.start(['rest', 'post', 'rest/fake', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end
  end

  describe '#rest put' do
    it 'makes a rest call with any data that is passed in' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
        .with('put', '/rest/fake', body: data).and_return FakeResponse.new(response)
      expect { described_class.start(['rest', 'put', 'rest/fake', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end
  end

  describe '#rest patch' do
    it 'makes a rest call with any data that is passed in' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
        .with('patch', '/rest/fake', body: data).and_return FakeResponse.new(response)
      expect { described_class.start(['rest', 'patch', 'rest/fake', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end
  end

  describe '#rest delete' do
    it 'makes a rest call with any data that is passed in' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api)
        .with('delete', '/rest/fake', body: data).and_return FakeResponse.new(response)
      expect { described_class.start(['rest', 'delete', 'rest/fake', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end
  end
end
