# coding: utf-8

module RbaseTaskHelpers
  module_function

  def app_root_path
    File.expand_path(File.join(File.dirname(__FILE__), '../../..'))
  end

  def rbase_plugins_config_path
    File.expand_path(File.join(app_root_path, 'rbase_plugins.yml'))
  end

  def load_rbase_plugin_paths
    rbase_plugins = Psych.load_file(rbase_plugins_config_path) || {}
    rbase_plugins.values.flatten
  end

  def plugin_name_from_path(path)
    path.split('/').last
  end

  def extract_rbase_gem_name(path)
    match = path.match(%r{rbase_gems/([^/]+)/})
    match && match[1]
  end

  def extract_rbase_gem_path_parts(path)
    match = path.match(/\A.*rbase_gems\/(rbase_[^\/]+)\/(.*)\Z/)
    return nil unless match && match[1] && match[2]

    [match[1], match[2]]
  end

  def remove_symlinks_with_warning(paths, warning_message)
    symlink_paths = paths.select { |path| File.symlink?(path) }
    undeleted_paths = paths - symlink_paths
    unless undeleted_paths.empty?
      puts "#{warning_message}: #{undeleted_paths}"
    end
    symlink_paths.each do |path|
      FileUtils.rm(path, :verbose => true)
    end
  end
end
