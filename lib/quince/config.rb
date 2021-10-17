module Quince
  class Config
    class << self
      attr_reader :props_struct_type, :state_struct_type

      def base
        props typed: ENV["RACK_ENV"] != "production"
        state typed: ENV["RACK_ENV"] != "production"
        sinatra_config do
          configure :development do
            if Object.const_defined? "Sinatra::Reloader"
              register Sinatra::Reloader
              dont_reload __FILE__
              also_reload $0
            end
          end
          enable :logging
          use Rack::JSONBodyParser
          use Rack::Deflater
          set :public_folder, File.join(File.dirname(File.expand_path($0)), "public")
        end
      end

      private

      def props(typed:)
        @props_struct_type = typed ? Quince::TypedStruct : Quince::Struct
      end

      def state(typed:)
        @state_struct_type = typed ? Quince::TypedStruct : Quince::Struct
      end

      def sinatra_config(&block)
        Quince::SinatraApp.instance_exec &block
      end
    end
  end
end
