require_relative '_client'

# List volume attachments
puts "\nVolume attachments available: "
OneviewSDK::VolumeAttachment.find_by(@client, {}).each do |volume_attachment|
  puts "- #{volume_attachment['hostName']}"
end

# List extra unmanaged storage volumes
extra_managed_volumes = OneviewSDK::VolumeAttachment.get_extra_unmanaged_volumes(@client)['members']
puts "\nUnmanaged volumes: " unless extra_managed_volumes.empty?
extra_managed_volumes.each do |unmanaged_volume|
  puts "- #{unmanaged_volume['ownerUri']}"
end

# List extra unmanaged storage volumes
volume_attachment = OneviewSDK::VolumeAttachment.find_by(@client, {}).first
if volume_attachment
  volume_paths = volume_attachment.get_paths
  puts "\nVolume #{volume_attachment['hostName']} paths: " unless volume_paths.empty?
  volume_paths.each do |path|
    puts "- #{path['initiatorName']}"
  end
end
