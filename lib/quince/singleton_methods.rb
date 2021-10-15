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

    def define_constructor(const, constructor_name = nil)
      if const.name
        parts = const.name.split("::")
        parent_namespace = Object.const_get(parts[0...-1].join("::")) if parts.length > 1
        constructor_name ||= parts.last
      end
      constructor_name ||= const.to_s

      HtmlTagComponents.instance_eval do
        mthd = lambda do |*children, **props, &block_children|
          new_props = {
            **props,
            Quince::Component::PARENT_SELECTOR_ATTR => __id,
          }
          const.create(*children, **new_props, &block_children)
        end

        if parent_namespace
          parent_namespace.instance_exec do
            define_method(constructor_name, &mthd)
          end
        else
          define_method(constructor_name, &mthd)
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
          case render_with
          when :render
            if output.is_a?(Array)
              raise "#render in #{tmp.class} should not return multiple elements. Consider wrapping it in a div"
            end
          else
            internal = Quince::Serialiser.serialise tmp
            updated_state = CGI.escapeHTML(internal).to_json
            selector = tmp.instance_variable_get :@state_container
            event = tmp.instance_variable_get :@callback_event

            scr = to_html(HtmlTagComponents::Script.create(<<~JS, type: "text/javascript"))
              var stateContainer = document.querySelector(`#{selector}`);
              stateContainer.dataset.quOn#{event}State = #{updated_state};
            JS
            output = output.render if output.is_a?(Component)

            output += (output.is_a?(String) ? scr : [scr])
          end
        else
          raise "don't know how to render #{output.class} (#{output.inspect})"
        end
      end

      output
    end
  end
end

############## TODO #############
# I think you should be able to know when a component is the first to be called in a render method,
# so you should be able to attach some props to it behind the scenes. Then any consumers of this
# state just have to know the selector, so they can read from it before passing it to the back end.
#
# Also, the front end needs to be updated such that script tags from the back end are always read
