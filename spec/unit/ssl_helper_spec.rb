require_relative './../spec_helper'
require 'uri'

# Tests for the SSLHelper module
RSpec.describe OneviewSDK::SSLHelper do
  include_context 'shared context'

  let(:valid_url) { 'https://ov.example.com' }

  before :each do
    allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_call_original
  end

  it 'sets the CERT_STORE constant' do
    expect(described_class::CERT_STORE).to include('/.oneview-sdk-ruby/trusted_certs.cer')
  end

  describe '#load_trusted_certs' do
    it 'returns a OpenSSL::X509::Store' do
      expect(File).to receive(:file?).with(described_class::CERT_STORE).and_return false
      ret = described_class.load_trusted_certs
      expect(ret).to be_a(OpenSSL::X509::Store)
    end

    it 'attempts to add the CERT_STORE file if found' do
      expect(File).to receive(:file?).with(described_class::CERT_STORE).and_return true
      expect_any_instance_of(OpenSSL::X509::Store).to receive(:add_file).with(described_class::CERT_STORE).and_return true
      described_class.load_trusted_certs
    end

    it 'handles file load failures' do
      expect(File).to receive(:file?).with(described_class::CERT_STORE).and_return true
      expect_any_instance_of(OpenSSL::X509::Store).to receive(:add_file).with(described_class::CERT_STORE).and_raise 'Error'
      expect(STDOUT).to receive(:puts).with(/WARNING: Failed to load certificate store file/)
      ret = described_class.load_trusted_certs
      expect(ret).to be_a(OpenSSL::X509::Store)
    end

    it 'returns nil if an unexpected failure occurs' do
      expect_any_instance_of(OpenSSL::X509::Store).to receive(:set_default_paths).and_raise 'Error'
      expect(STDOUT).to receive(:puts).with(/WARNING: Failure/)
      ret = described_class.load_trusted_certs
      expect(ret).to be_nil
    end
  end

  describe '#check_cert' do
    context 'with invalid options' do
      it 'requires a url' do
        expect { described_class.check_cert }.to raise_error ArgumentError
      end

      it 'requires a valid url' do
        expect { described_class.check_cert('blah') }.to raise_error(OneviewSDK::InvalidURL, /Invalid url/)
        expect { described_class.check_cert('http://') }.to raise_error(/(Invalid url)|(bad URI)/) # Differs on Ruby 2.1 and 2.2
        expect { described_class.check_cert('10.0.0.1') }.to raise_error(OneviewSDK::InvalidURL, /Invalid url/)
      end
    end

    it 'loads the trusted certs' do
      expect(described_class).to receive(:load_trusted_certs).and_return(true)
      allow_any_instance_of(Net::HTTP).to receive(:cert_store=).and_return(true)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(nil)
      expect(described_class.check_cert(valid_url)).to be true
    end

    it 'returns false if ssl validation fails' do
      expect(described_class).to receive(:load_trusted_certs).and_return(nil)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise OpenSSL::SSL::SSLError
      expect(described_class.check_cert(valid_url)).to be false
    end
  end

  describe '#install_cert' do
    context 'with invalid options' do
      it 'requires a url' do
        expect { described_class.install_cert }.to raise_error ArgumentError
      end

      it 'requires a valid url' do
        expect { described_class.install_cert('blah') }.to raise_error(OneviewSDK::InvalidURL, /Invalid url/)
        expect { described_class.check_cert('http://') }.to raise_error(/(Invalid url)|(bad URI)/) # Differs on Ruby 2.1 and 2.2
        expect { described_class.install_cert('10.0.0.1') }.to raise_error(OneviewSDK::InvalidURL, /Invalid url/)
      end
    end

    before :each do
      @uri = URI.parse(CGI.escape(valid_url))
      @cert_dir = File.dirname(described_class::CERT_STORE)
    end

    it 'attempts to downloads the cert from the server' do
      expect(Net::HTTP).to receive(:start).with(@uri.host, @uri.port, Hash) { nil }
      expect { described_class.install_cert(valid_url) }.to raise_error(/Could not download cert/)
    end

    it 'attempts to create the .oneview-sdk-ruby dir' do
      expect(Net::HTTP).to receive(:start).with(@uri.host, @uri.port, Hash) { 'fake_cert' }
      expect(File).to receive(:directory?).with(@cert_dir).and_return false
      expect(Dir).to receive(:mkdir).with(@cert_dir).and_raise 'Create dir'
      expect { described_class.install_cert(valid_url) }.to raise_error(/Create dir/)
    end

    it 'skips adding the cert if it is already present' do
      expect(Net::HTTP).to receive(:start).with(@uri.host, @uri.port, Hash) { 'fake_cert' }
      allow(Dir).to receive(:mkdir).with(@cert_dir).and_return true
      expect(File).to receive(:file?).with(described_class::CERT_STORE).and_return true
      expect(File).to receive(:read).with(described_class::CERT_STORE).and_return "f\nfake_cert\n"
      expect(STDOUT).to receive(:puts).with(/Cert store already contains this certificate/)
      expect(described_class.install_cert(valid_url)).to be false
    end

    it 'adds the cert if it is not present' do
      expect(Net::HTTP).to receive(:start).with(@uri.host, @uri.port, Hash) { 'fake_cert' }
      allow(Dir).to receive(:mkdir).with(@cert_dir).and_return true
      expect(File).to receive(:file?).with(described_class::CERT_STORE).and_return true
      expect(File).to receive(:read).with(described_class::CERT_STORE).and_return "f\nother_cert\n"
      expect(File).to receive(:open).with(described_class::CERT_STORE, 'a') { true }
      expect(STDOUT).to receive(:puts).with(/Cert added/)
      expect(described_class.install_cert(valid_url)).to be true
    end
  end
end
