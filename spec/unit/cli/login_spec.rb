require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#login' do
    let(:command) { OneviewSDK::Cli.start(['login']) }

    it 'prints the token' do
      expect { command }.to output(/Login Successful! Token = secret456/).to_stdout_from_any_process
    end
  end
end
