require 'yaml'

class AppConfig
  @@parsed_body = YAML.load(File.open(ENV["CONFIG_DIR"] + 'config.yml').read)

  def self.parsed_body
    @@parsed_body
  end
end
