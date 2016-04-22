require 'uri'
require 'net/http'
require 'openssl'

module OneviewSDK
  # SSL Certificate helper
  module SSLHelper
    CERT_STORE = File.join(Dir.home, '/.oneview-sdk-ruby/trusted_certs.cer')

    # Load any trusted certs and add them to the default SSL cert store.
    #   Looks for a file at ~/.oneview-sdk-ruby/trusted_certs.cer
    #   Note: File must be readable and parseable by X509::Store.add_file method
    # @return [X509::Store] cert_store
    def self.load_trusted_certs
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      begin
        store.add_file(CERT_STORE) if File.file?(CERT_STORE)
      rescue StandardError => e
        puts "WARNING: Failed to load certificate store file at #{CERT_STORE} \n  Message: #{e.message}"
      end
      store
    rescue StandardError => e
      puts "WARNING: Failure in #{self}##{__method__} \n  Message: #{e.message}"
      nil
    end

    # Check to see if a OneView instance's certificate is trusted
    # @param [String] url URL of the OneView Instance to be added
    # @return [Boolean] Whether or not certificate is trusted
    # @raise [RuntimeError] if the url is invalid
    def self.check_cert(url)
      uri = URI.parse(URI.escape(url))
      fail "Invalid url '#{url}'" unless uri.host
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      trusted_certs = load_trusted_certs
      http.cert_store = trusted_certs if trusted_certs
      http.request(Net::HTTP::Get.new(uri.request_uri))
      true
    rescue OpenSSL::SSL::SSLError
      false
    end

    # Fetch and add the ssl certificate of a OneView instance to the trusted certs store.
    #   Creates/modifies file at ~/.oneview-sdk-ruby/trusted_certs.cer
    # @param [String] url URL of the OneView Instance to be added
    # @raise [RuntimeError] if the url is invalid
    def self.install_cert(url)
      uri = URI.parse(URI.escape(url))
      fail "Invalid url '#{url}'" unless uri.host
      options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
      pem = Net::HTTP.start(uri.host, uri.port, options) do |http|
        http.peer_cert.to_pem
      end
      fail "Could not download cert from #{url}. You may have to do it manually, and append it to '#{CERT_STORE}'" if pem.nil?

      name = "OneView at #{url}"
      content = "\n#{name}\n"
      content << "#{'=' * name.length}\n"
      content << pem

      cert_dir = File.dirname(CERT_STORE)
      Dir.mkdir(cert_dir) unless File.directory?(cert_dir)
      if File.file?(CERT_STORE) && File.read(CERT_STORE).include?(pem)
        puts 'Cert store already contains this certificate. Skipped!'
        false
      else
        File.open(CERT_STORE, 'a') { |f| f.write content }
        puts "Cert added to '#{CERT_STORE}'. Cert Info: #{content}"
        true
      end
    end
  end
end
