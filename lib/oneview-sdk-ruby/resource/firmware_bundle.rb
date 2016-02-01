
module OneviewSDK
  # Resource for firmware bundles
  class FirmwareBundle
    BASE_URI = '/rest/firmware-bundles'.freeze
    BOUNDARY = '---OneView-SDK-RubyFormBoundaryWzS4H31b7UMbKMCx'.freeze

    # Upload a firmware bundle file
    # @param [OneviewSDK::Client] client
    # @param [String] file_path
    # @return [OneviewSDK::FirmwareDriver] if the upload was sucessful, return a FirmwareDriver object
    def self.upload(client, file_path)
      fail "ERROR: File '#{file_path}' not found!" unless File.file?(file_path)
      type = case File.extname(file_path)
             when '.zip' then 'application/x-zip-compressed'
             when '.exe' then 'application/x-msdownload'
             else 'application/octet-stream'
             end

      body = "--#{BOUNDARY}\r\n"
      body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{File.basename(file_path)}\"\r\n"
      body << "Content-Type: #{type}\r\n\r\n"
      body << File.read(file_path)
      body << "\r\n--#{BOUNDARY}--"

      options = {
        'Content-Type' => "multipart/form-data; boundary=#{BOUNDARY}",
        'uploadfilename' => File.basename(file_path),
        'body' => body
      }

      response = client.rest_post(BASE_URI, options)
      data = client.response_handler(response)
      OneviewSDK::FirmwareDriver.new(client, data)
    end

  end
end
