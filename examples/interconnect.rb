require_relative '_client'

# List of interconnects
OneviewSDK::Interconnect.find_by(@client, {}).each { |interconnect| puts interconnect['uri'] }

# Retrieve interconnect
interconnect = OneviewSDK::Interconnect.new(@client, name: 'Encl2, interconnect 2')
interconnect.retrieve!
puts interconnect.nameServers
puts interconnect.statistics('x7')
interconnect.update_port('X7', enabled: false)
interconnect.resetportprotection
