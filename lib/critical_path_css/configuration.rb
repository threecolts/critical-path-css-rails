require 'erb'
module CriticalPathCss
  class Configuration
    def initialize(config)
      @config = config
    end

    def base_url
      @config['base_url']
    end

    def css_paths
      @config['css_paths']
    end

    def manifest_name
      @config['manifest_name']
    end

    def routes
      @config['routes']
    end

    def out_dir
      @config['out_dir']
    end

    def penthouse_options
      @config['penthouse_options'] || {}
    end

    def path_for_route(route)
      if css_paths.length() == 1
        return css_paths[0]
      end

      css_paths[routes.index(route).to_i]
    end
  end
end
