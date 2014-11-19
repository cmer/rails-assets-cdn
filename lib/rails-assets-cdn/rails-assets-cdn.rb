module RailsAssetsCdn
  class Railtie < ::Rails::Railtie
    def initialize_railtie
      Rails.logger.info "Initializing rails-assets-cdn..."
      $rails_assets_cdn_initialized = false

      config = nil
      %w(assets_cdn.yml cdn.yml).each do |filename|
        config_path = Rails.root.join('config', filename)
        if File.exist?(config_path)
          Rails.logger.info "  Reading config file at #{config_path}..."
          config = YAML.load(ERB.new(File.read(config_path)).result)[Rails.env]
          break
        end
      end

      unless config
        Rails.logger.info "  Couldn't find configuration file. Skipping initialization."
        return false
      end

      # Set defaults
      config['enabled']           = true      if config['enabled'].nil?
      config['protocol']          = 'browser' if config['protocol'].nil?
      config['fallback_protocol'] = 'http'    if config['fallback_protocol'].nil?
      config['protocol'].sub!('://', '')
      config['fallback_protocol'].sub!('://', '')

      # Validations
      unless config['enabled']
        Rails.logger.info "  rails-assets-cdn is disabled. Bye bye!"
        return false
      end

      raise ArgumentError.new("Protocol #{config["protocol"]} is invalid.") \
        unless %w(browser request http https).include?(config['protocol'])
      raise ArgumentError.new("Fallback protocol #{config["fallback_protocol"]} is invalid.") \
        unless %w(http https).include?(config['fallback_protocol'])
      raise ArgumentError.new("CDN hosts not specified.") \
        unless (config['hosts'] || config['host']).present?

      $rails_assets_cdn = {}
      $rails_assets_cdn[:hosts]             = Array.wrap(config['hosts'] || config['host'])
      $rails_assets_cdn[:fallback_protocol] = config['fallback_protocol'] + "://"
      $rails_assets_cdn[:protocol]     = case config['protocol'].to_sym
        when :browser; '//'           # Let browser decide on protocol
        when :request; nil            # Same protocol as the current request, but hardcoded
        when :http;    'http://'      # Force http
        when :https;   'https://'     # Force https
      end

      Rails.logger.info "  CDN hosts: #{$rails_assets_cdn[:hosts].to_sentence}."
      Rails.logger.info "  Protocol strategy: #{$rails_assets_cdn[:protocol]} (fallback: #{$rails_assets_cdn[:fallback_protocol]})."

      ActionController::Base.asset_host = Proc.new do |source, request|
        protocol = if $rails_assets_cdn[:protocol]
          $rails_assets_cdn[:protocol]
        else
          request ? request.protocol : $rails_assets_cdn[:fallback_protocol]
        end

        $rails_assets_cdn[:hosts].map { |host| protocol.to_s + host }[source.hash % $rails_assets_cdn[:hosts].size]
      end

      $rails_assets_cdn[:initialized] = true
    end

    initializer "rails_assets_cdn.initialize" do
      self.initialize_railtie
    end
  end
end
