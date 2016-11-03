require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  # This is commented out because a 'monitored' enclosure can't be removed unless it loses
  # connectivity, which involves physically detaching the cables from the hardware
  # describe '#remove' do
  #   it 'removes the resource' do
  #     item = klass.find_by($client_300_thunderbird, name: ENCL_NAME).first
  #     expect { item.remove }.not_to raise_error
  #   end
  # end
end
