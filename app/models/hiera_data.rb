class HieraData
  class EnvironmentNotFound < StandardError; end

  attr_reader :environment

  def initialize(environment)
    @environment = environment

    raise EnvironmentNotFound.new("Environment '#{environment}' does not exist") unless PuppetDbClient.environments.include?(environment)
  end

  def all_keys(facts)
    keys = []
    config.hierarchies.each do |hierarchy|
      hierarchy.resolved_paths(facts: facts).each do |path|
        file = YamlFile.new(path: hierarchy.datadir.join(path))
        keys.concat(file.keys)
      end
    end
    keys.sort.uniq
  end

  def search_key(facts, key)
    search_results = {}
    config.hierarchies.each do |hierarchy|
      search_results[hierarchy.name] = []
      hierarchy.resolved_paths(facts: facts).each do |path|
        file = YamlFile.new(path: hierarchy.datadir.join(path))
        search_results[hierarchy.name] << {
          path: path,
          file_present: file.exist?,
          key_present: file.keys.include?(key),
          value: file.content_for_key(key)
        }
      end
    end
    search_results
  end

  def write_key(hierarchy_name, path, key, value)
    hierarchy = find_hierarchy(hierarchy_name)
    read_file = YamlFile.new(path: hierarchy.datadir.join(path))
    read_file.write_key(key, value)
  end

  def remove_key(hierarchy_name, path, key)
    hierarchy = find_hierarchy(hierarchy_name)
    read_file = YamlFile.new(path: hierarchy.datadir.join(path))
    read_file.remove_key(key)
  end

  private

  def config_dir
    @config_dir ||= Rails.configuration.hdm["config_dir"]
  end

  def config
    @config ||= Config.new(Pathname.new(config_dir).join("environments", environment))
  end

  def find_hierarchy(name)
    config.hierarchies.find { |h| h.name == name }
  end
end
