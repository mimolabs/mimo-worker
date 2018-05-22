MIMO_CONFIG = YAML.safe_load(ERB.new(File.read(File.dirname(__FILE__) + '/../mimo-config.yml')).result)
