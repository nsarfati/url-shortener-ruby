require 'yaml'

class AppConfig

  def initialize()
    @parsed_body = YAML.load(File.open(ENV["CONFIG_DIR"] + 'config.yml').read)
  end

  def get_config
    @parsed_body
  end
end
