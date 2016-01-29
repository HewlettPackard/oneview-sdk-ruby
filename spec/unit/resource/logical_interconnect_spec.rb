require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect do
  include_context 'shared context'

  let(:enet_trap) { %w(Other PortStatus PortThresholds) }
  let(:fc_trap) { %w(Other PortStatus) }
  let(:vcm_trap) { %w(Legacy) }
  let(:trap_sev) { %w(Normal Info Warning Critical Major Minor Unknown) }

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::LogicalInterconnect.from_file(@client, fixture_path) }

  describe 'SNMP Configuration' do
    it 'builds the trap options successfully' do
      opt = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
      expect((enet_trap.map { |x| opt['enetTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((fc_trap.map { |x| opt['fcTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((vcm_trap.map { |x| opt['vcmTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((trap_sev.map { |x| opt['trapSeverities'].include?(x) }).include?(false)).to eq(false)
    end

    it 'builds the trap options even with duplicates' do
      new_enet_trap = enet_trap + ['Other']
      new_fc_trap = fc_trap + ['Other']
      new_vcm_trap = vcm_trap + ['Legacy']
      new_trap_sev = trap_sev + ['Critical']
      opt = log_int.generate_trap_options(new_enet_trap, new_fc_trap, new_vcm_trap, new_trap_sev)
      expect((enet_trap.map { |x| opt['enetTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((fc_trap.map { |x| opt['fcTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((vcm_trap.map { |x| opt['vcmTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((trap_sev.map { |x| opt['trapSeverities'].include?(x) }).include?(false)).to eq(false)
    end

    it 'adds one trap destination successfully' do
      opt = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
      log_int.add_snmp_trap_destination('172.18.6.16', 'SNMPv1', 'public', opt)
      entry = log_int['snmpConfiguration']['trapDestinations'].first
      expect(entry['trapDestination']).to eq('172.18.6.16')
      expect(entry['trapFormat']).to eq('SNMPv1')
      expect(entry['communityString']).to eq('public')
    end

    describe 'will not let weird values in the fields' do
      it 'enetTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(/not one of the allowed values/)
      end

      it 'fcTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(/not one of the allowed values/)
      end

      it 'vcmTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(/not one of the allowed values/)
      end

      it 'trapSeverities' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(/not one of the allowed values/)
      end

      it 'trapFormat' do
        expect { log_int.add_snmp_trap_destination('172.18.6.16', 'NO_VERSION', 'public') }
      end
    end

  end
end
