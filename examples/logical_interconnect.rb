require_relative '_client'

type = 'Logical Interconnect'

# Explores functionalities of Logical Interconnects

log_int = OneviewSDK::LogicalInterconnect.new(@client, {})

# Create interconnect in Bay 1 of Enclosure 1
log_int.create_interconnect(1, 1)
