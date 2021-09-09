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

      def exposed(action, meth0d: :POST)
        @exposed_actions ||= Set.new
        @exposed_actions.add action
        route = "/api/#{self.name}/#{action}"
        Quince.middleware.create_route_handler(
          verb: meth0d,
          route: route,
        ) do |params|
          instance = Quince::Serialiser.deserialise params[:component]
          if @exposed_actions.member? action
            if instance.method(action).arity.zero?
              instance.send action
            else
              instance.send action, params[:params]
            end
            instance
          else
            raise "The action you called is not exposed"
          end
        end

        route
      end

      def initial_state=(attrs)
        @initial_state ||= self::State.new(**attrs)
      end

      attr_reader :initial_state

      private

      def initialize_props(const, id, **props)
        const::Props.new(HTML_SELECTOR_ATTR => id, **props) if const.const_defined?("Props")
      end
    end

    attr_reader :props, :state, :children

    def initialize(*children, **props, &block_children)
      @__id = SecureRandom.alphanumeric(6)
      @props = self.class.send :initialize_props, self.class, @__id, **props
      @state = self.class.initial_state
      @children = block_children || children
    end

    def render
      raise "not implemented"
    end

    protected

    def to(route, via: :POST)
      self.class.exposed route, meth0d: via
    end

    private

    attr_reader :__id

    HTML_SELECTOR_ATTR = :"data-respid"

    def html_element_selector
      "[#{HTML_SELECTOR_ATTR}='#{__id}']".freeze
    end
  end
end
