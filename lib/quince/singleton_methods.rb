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
        component = component.new if component.instance_of? Class

        Quince.middleware.create_route_handler(
          verb: :GET,
          route: at,
          component: component,
        )
      end
    end

    def define_constructor(const, constructor_name = const.to_s)
      HtmlTagComponents.instance_eval do
        define_method(constructor_name) do |*children, **props, &block_children|
          new_props = { **props, Quince::Component::HTML_SELECTOR_ATTR => __id }
          const.new(*children, **new_props, &block_children)
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
        else
          tmp = output
          output = output.render
          if output.is_a?(Array)
            raise "#render in #{tmp.class} should not return multiple elements. Consider wrapping it in a div"
          end
        end
      end

      output
    end
  end
end
