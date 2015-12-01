require_relative '_client'

# Example: Create a Logical Interconnect Group
options = {
  name: 'OneViewSDK Test NoUp LIG',
  enclosureType: "C7000",
  type: 'logical-interconnect-groupV3'
}

HP_VC_FF_24_MODEL = 'HP VC FlexFabric 10Gb/24-Port Module'

lig = OneviewSDK::LogicalInterconnectGroup.new(@client, options)

# Add the interconnects to the bays 1 and 2
lig.add_interconnect(1, HP_VC_FF_24_MODEL)
lig.add_interconnect(2, HP_VC_FF_24_MODEL)

puts "The LIG: #{lig["interconnectBayMap"]}"

lig.create
