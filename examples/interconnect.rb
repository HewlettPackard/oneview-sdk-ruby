require_relative '_client'

# List of interconnects
OneviewSDK::Interconnect.find_by(@client, {}).each do |interconnect|
  puts "Interconnect #{interconnect['name']} URI=#{interconnect['uri']}"

  # Retrieve name servers
  puts " - Name servers: #{interconnect.nameServers}"
end

# Retrieve interconnect
interconnect = OneviewSDK::Interconnect.new(@client, name: 'Encl2, interconnect 2')
interconnect.retrieve!

# Resert Port Protection
puts "Reseting port protection for interconnect #{interconnect['name']}"
interconnect.resetportprotection
