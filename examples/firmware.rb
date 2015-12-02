require_relative '_client' # Gives access to @client

# NOTE: This will add a firmware bundle, then delete it.


# Example: Add firmware bundle
type = 'firmware bundle'
file_path = 'spec/support/fixtures/integration/test.zip'

begin
  item = OneviewSDK::FirmwareBundle.upload(@client, file_path)
  puts "\nUpload of #{type} '#{item[:name]}' sucessful.\n  uri = '#{item[:uri]}'"
rescue StandardError => e
  printf "\nUpload Error: "
  puts JSON.parse(e.message.split('Response: ').last).first['message'] rescue e.message
end


# Example: Search firmware drivers by name
type = 'firmware bundle'

item2 = OneviewSDK::FirmwareDriver.find_by(@client, name: File.basename(file_path)).first
puts "\nFound #{type} '#{item2[:name]}' by name.\n  uri = '#{item2[:uri]}'"


# Example: Delete firmware driver
item2.delete
puts "\nSucessfully deleted #{type} '#{item2[:name]}'."
