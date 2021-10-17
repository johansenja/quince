# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require "sinatra/base"
require "sinatra/reloader" if ENV["RACK_ENV"] == "development"
require "rack/contrib"

module Quince
  class SinatraApp < Sinatra::Base
    configure :development do
      if Object.const_defined? "Sinatra::Reloader"
        register Sinatra::Reloader
        dont_reload __FILE__
        also_reload $0
      end
    end
    use Rack::JSONBodyParser
    use Rack::Deflater
    set :public_folder, File.join(File.dirname(File.expand_path($0)), "public")

    class << self
      def create_route_handler(verb:, route:, &blck)
        meth = case verb
          when :POST, :post
            :post
          when :GET, :get
            :get
          else
            raise "invalid verb"
          end

        public_send meth, route do
          Quince.to_html(blck.call(binding))
        ensure
          Thread.current[:request_binding] = nil
          Thread.current[:params] = nil
        end
      end
    end
  end
end

def expose(component, at:)
  Quince::SinatraApp.get(at) do
    Thread.current[:request_binding] = binding
    Thread.current[:params] = binding.receiver.params
    comp = component.instance_of?(Class) ? component.create : component
    comp.instance_variable_set :@render_with, :render
    Quince.to_html(comp)
  ensure
    Thread.current[:request_binding] = nil
    Thread.current[:params] = nil
  end
end

at_exit do
  if $!.nil? || ($!.is_a?(SystemExit) && $!.success?)
    if Object.const_defined? "Sinatra::Reloader"
      app_dir = Pathname(File.expand_path($0)).dirname.to_s
      $LOADED_FEATURES.each do |f|
        next unless f.start_with? app_dir

        Quince::SinatraApp.also_reload f
      end
    end

    Quince::SinatraApp.run!
  end
end
