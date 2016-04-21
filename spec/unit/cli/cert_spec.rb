require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#cert' do
    context 'with invalid options' do
      it 'requires an action' do
        expect { OneviewSDK::Cli.start(['cert']) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid action' do
        expect(STDOUT).to receive(:puts).with(/Invalid action/)
        expect { OneviewSDK::Cli.start(%w(cert blah)) }.to raise_error SystemExit
      end
    end
  end

  describe '#cert check' do
    context 'with invalid options' do
      it 'requires a url' do
        ENV['ONEVIEWSDK_URL'] = nil
        expect(STDOUT).to receive(:puts).with(/Must specify a url/)
        expect { OneviewSDK::Cli.start(%w(cert check)) }
          .to raise_error SystemExit
      end

      it 'requires a valid url' do
        ENV['ONEVIEWSDK_URL'] = nil
        expect(STDOUT).to receive(:puts).with(/Checking certificate for/)
        expect(STDOUT).to receive(:puts).with(/Invalid url/)
        expect { OneviewSDK::Cli.start(%w(cert check blah)) }
          .to raise_error SystemExit
      end
    end

    context 'with valid options' do
      it 'uses the ONEVIEWSDK_URL environment variable' do
        expect(STDOUT).to receive(:puts).with(/Checking certificate for/)
        expect(STDOUT).to receive(:puts).with(/Certificate is valid!/)
        expect(OneviewSDK::SSLHelper).to receive(:check_cert).with(ENV['ONEVIEWSDK_URL']).and_return true
        OneviewSDK::Cli.start(%w(cert check))
      end

      it 'takes a url parameter' do
        expect(STDOUT).to receive(:puts).with(/Checking certificate for/)
        expect(STDOUT).to receive(:puts).with(/Certificate is valid!/)
        expect(OneviewSDK::SSLHelper).to receive(:check_cert).with('https://two.example.com').and_return true
        OneviewSDK::Cli.start(%w(cert check https://two.example.com))
      end

      it 'tells the user when validation succeeds' do
        expect(STDOUT).to receive(:puts).with(/Checking certificate for/)
        expect(STDOUT).to receive(:puts).with(/Certificate is valid!/)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return true
        OneviewSDK::Cli.start(%w(cert check))
      end

      it 'tells the user when validation fails' do
        expect(STDOUT).to receive(:puts).with(/Checking certificate for/)
        expect(STDOUT).to receive(:puts).with(/Certificate Validation Failed/)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_raise OpenSSL::SSL::SSLError
        expect { OneviewSDK::Cli.start(%w(cert check)) }
          .to raise_error SystemExit
      end
    end
  end

  describe '#cert list' do
    it 'tells the user when no cert file is found' do
      expect(File).to receive(:file?).and_return false
      expect(STDOUT).to receive(:puts).with(/No certs imported!/)
      OneviewSDK::Cli.start(%w(cert list))
    end

    it 'prints the cert info when the cert file is found' do
      expect(File).to receive(:file?).and_return true
      expect(File).to receive(:read).and_return 'Content'
      expect(STDOUT).to receive(:puts).with(/Content/)
      OneviewSDK::Cli.start(%w(cert list))
    end
  end

  describe '#cert import' do
    context 'with invalid options' do
      it 'requires a url' do
        ENV['ONEVIEWSDK_URL'] = nil
        expect(STDOUT).to receive(:puts).with(/Must specify a url/)
        expect { OneviewSDK::Cli.start(%w(cert import)) }
          .to raise_error SystemExit
      end

      it 'requires a valid url' do
        ENV['ONEVIEWSDK_URL'] = nil
        expect(STDOUT).to receive(:puts).with(/Importing certificate for/)
        expect(STDOUT).to receive(:puts).with(/Invalid url/)
        expect { OneviewSDK::Cli.start(%w(cert import blah)) }
          .to raise_error SystemExit
      end
    end

    context 'with valid options' do
      it 'uses the ONEVIEWSDK_URL environment variable' do
        expect(STDOUT).to receive(:puts).with(/Importing certificate for/)
        expect(OneviewSDK::SSLHelper).to receive(:install_cert).with(ENV['ONEVIEWSDK_URL']).and_return true
        OneviewSDK::Cli.start(%w(cert import))
      end

      it 'takes a url parameter' do
        expect(STDOUT).to receive(:puts).with(/Importing certificate for/)
        expect(OneviewSDK::SSLHelper).to receive(:install_cert).with('https://two.example.com').and_return true
        OneviewSDK::Cli.start(%w(cert import https://two.example.com))
      end
    end
  end
end
