require_relative "callback"

module Quince
  class Component
    class << self
      def inherited(subclass)
        Quince.define_constructor(subclass)
      end

      def Props(**kw)
        self.const_set "Props", TypedStruct.new(
          { default: Quince::Types::Undefined },
          Quince::Component::HTML_SELECTOR_ATTR => String,
          **kw,
        )
      end

      def State(**kw)
        st = kw.empty? ? nil : TypedStruct.new(
          { default: Quince::Types::Undefined },
          **kw,
        )
        self.const_set "State", st
      end

      def exposed(action, method: :POST)
        @exposed_actions ||= Set.new
        @exposed_actions.add action
        route = "/api/#{self.name}/#{action}"
        Quince.middleware.create_route_handler(
          verb: method,
          route: route,
        ) do |params|
          instance = Quince::Serialiser.deserialise(CGI.unescapeHTML(params[:component]))
          Quince::Component.class_variable_set :@@params, params
          render_with = if params[:rerender]
                          params[:rerender][:method].to_sym
                        else
                          :render
                        end
          instance.instance_variable_set :@render_with, render_with
          if @exposed_actions.member? action
            instance.send action
            instance
          else
            raise "The action you called is not exposed"
          end
        end

        route
      end

      def create(*children, **props, &block_children)
        allocate.tap do |instance|
          id = SecureRandom.alphanumeric 6
          instance.instance_variable_set :@__id, id
          instance.instance_variable_set :@props, initialize_props(self, id, **props)
          kids = block_children ? block_children.call : children
          instance.instance_variable_set(:@children, kids)
          instance.send :initialize
        end
      end

      private

      def initialize_props(const, id, **props)
        const::Props.new(HTML_SELECTOR_ATTR => id, **props) if const.const_defined?("Props")
      end
    end

    include Callback::ComponentHelpers

    # set default
    @@params = {}

    attr_reader :props, :state, :children

    def render
      raise "not implemented"
    end

    protected

    def to(route, via: :POST)
      self.class.exposed route, method: via
    end

    def params
      @@params
    end

    private

    attr_reader :__id

    HTML_SELECTOR_ATTR = :"data-quid"

    def html_element_selector
      "[#{HTML_SELECTOR_ATTR}='#{__id}']".freeze
    end
  end
end
