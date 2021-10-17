ENV["RACK_ENV"] ||= "development"

require "sinatra/base"
require "sinatra/reloader" if ENV["RACK_ENV"] == "development"
require "rack/contrib"

require "securerandom"
require "typed_struct"
require "cgi"

require_relative "quince/config"
require_relative "quince/struct/typed"
require_relative "quince/struct/untyped"
require_relative "quince/sinatra"

module Quince
  def self.load_config!
    Quince::Config.base
    app_dir = File.dirname(File.expand_path($0))
    conf = Pathname(File.join(app_dir, "config.rb"))
    require conf.to_s if conf.exist?

    rack_env = ENV["RACK_ENV"]
    if Quince::Config.respond_to? rack_env
      Quince::Config.send rack_env
    end
  end
end

Quince.load_config!

require_relative "quince/singleton_methods"
require_relative "quince/component"
require_relative "quince/html_tag_components"
require_relative "quince/version"
