module Quince
  class << self
    attr_reader :middleware
    attr_accessor :underlying_app

    def optional_string
      @optional_string ||= Rbs("String?")
    end

    def middleware=(middleware)
      @middleware = middleware
      Object.define_method(:expose) do |component, at:|
        Quince.middleware.create_route_handler(
          verb: :GET,
          route: at,
        ) do |params|
          component = component.create if component.instance_of? Class
          Quince::Component.class_variable_set :@@params, params
          component.instance_variable_set :@render_with, :render
          component
        end
      end
      Object.send :private, :expose
    end

    def define_constructor(const, constructor_name = const.to_s)
      HtmlTagComponents.instance_eval do
        define_method(constructor_name) do |*children, **props, &block_children|
          new_props = { **props, Quince::Component::HTML_SELECTOR_ATTR => __id }
          const.create(*children, **new_props, &block_children)
        end
      end
    end

    def to_html(component)
      output = component

      until output.is_a? String
        case output
        when Array
          output = output.map { |c| to_html(c) }.join
        when String
          break
        when Proc
          output = to_html(output.call)
        when NilClass
          output = ""
        when Component
          tmp = output
          render_with = output.instance_variable_get(:@render_with) || :render
          output = output.send render_with
          if output.is_a?(Array) && render_with == :render
            raise "#render in #{tmp.class} should not return multiple elements. Consider wrapping it in a div"
          end
        else
          raise "don't know how to render #{output.class} (#{output.inspect})"
        end
      end

      output
    end
  end
end
