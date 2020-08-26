require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#env' do
    let(:command) { OneviewSDK::Cli.start(['env']) }

    it 'shows ONEVIEWSDK_URL' do
      expect { command }.to output(%r{ONEVIEWSDK_URL\s+=\s'https:\/\/oneview\.example\.com'}).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_USER' do
      expect { command }.to output(/ONEVIEWSDK_USER\s+=\s'Admin'/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_PASSWORD' do
      ENV['ONEVIEWSDK_PASSWORD'] = 'secret123'
      expect { command }.to output(/ONEVIEWSDK_PASSWORD\s+=\s'secret123'/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_DOMAIN' do
      ENV['ONEVIEWSDK_DOMAIN'] = 'Other'
      expect { command }.to output(/ONEVIEWSDK_DOMAIN\s+=\s'Other'/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_TOKEN' do
      expect { command }.to output(/ONEVIEWSDK_TOKEN\s+=\s'secret456'/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_SSL_ENABLED as nil' do
      expect { command }.to output(/ONEVIEWSDK_SSL_ENABLED\s+=\snil/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_SSL_ENABLED when set' do
      ENV['ONEVIEWSDK_SSL_ENABLED'] = 'false'
      expect { command }.to output(/ONEVIEWSDK_SSL_ENABLED\s+=\sfalse/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_API_VERSION when set' do
      ENV['ONEVIEWSDK_API_VERSION'] = '600'
      expect { command }.to output(/ONEVIEWSDK_API_VERSION\s+=\s'600'/).to_stdout_from_any_process
    end

    it 'shows ONEVIEWSDK_VARIANT when set' do
      ENV['ONEVIEWSDK_VARIANT'] = 'Synergy'
      expect { command }.to output(/ONEVIEWSDK_VARIANT\s+=\s'Synergy'/).to_stdout_from_any_process
    end

    it 'shows I3S_URL' do
      expect { command }.to output(%r{I3S_URL\s+=\s'https:\/\/i3s\.example\.com'}).to_stdout_from_any_process
    end

    it 'shows I3S_SSL_ENABLED as nil' do
      expect { command }.to output(/I3S_SSL_ENABLED\s+=\snil/).to_stdout_from_any_process
    end

    it 'shows I3S_SSL_ENABLED when set' do
      ENV['I3S_SSL_ENABLED'] = 'false'
      expect { command }.to output(/I3S_SSL_ENABLED\s+=\sfalse/).to_stdout_from_any_process
    end

    it 'prints the resource details in json format' do
      data = {}
      OneviewSDK::ENV_VARS.each { |k| data[k] = ENV[k] }
      expect { OneviewSDK::Cli.start(%w[env -f json]) }.to output(JSON.pretty_generate(data) + "\n").to_stdout_from_any_process
    end
  end
end
