require 'critical_path_css/configuration'
require 'critical_path_css/css_fetcher'
require 'critical_path_css/rails/config_loader'
require 'digest'

module CriticalPathCss
  CACHE_NAMESPACE = 'critical-path-css'.freeze

  def self.generate(route)
    css = fetcher.fetch_route(route)
    hsh = Digest::SHA256.hexdigest(route)
    puts hsh + "\t" + route
    #::Rails.cache.write(route, css, namespace: CACHE_NAMESPACE, expires_in: nil)
    fn = ::Rails.root.join(fetcher.config.out_dir, hsh + ".css")
    puts fn
    File.open(fn, "w") {|f| f.write(css)}
  end

  def self.generate_all
    fetcher.fetch.each do |route, css|
      #::Rails.cache.write(route, css, namespace: CACHE_NAMESPACE, expires_in: nil)
      hsh = Digest::SHA256.hexdigest(route)
      puts hsh + "\t" + route
      fn = ::Rails.root.join(fetcher.config.out_dir, hsh + ".css")
      puts fn
      File.open(fn, "w") {|f| f.write(css)}
    end
  end

  def self.clear(route)
    ::Rails.cache.delete(route, namespace: CACHE_NAMESPACE)
  end

  def self.clear_matched(routes)
    ::Rails.cache.delete_matched(routes, namespace: CACHE_NAMESPACE)
  end

  def self.fetch(route)
    ::Rails.cache.read(route, namespace: CACHE_NAMESPACE) || ''
  end

  def self.fetcher
    @fetcher ||= CssFetcher.new(Configuration.new(config_loader.config))
  end

  def self.config_loader
    @config_loader ||= CriticalPathCss::Rails::ConfigLoader.new
  end
end
