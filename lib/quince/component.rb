require "forwardable"
require_relative "callback"

module Quince
  class Component
    class << self
      def inherited(subclass)
        Quince.define_constructor(subclass)
      end

      def Props(**kw)
        self.const_set "Props", Quince::Config.props_struct_type.new(
          Quince::Component::PARENT_SELECTOR_ATTR => String,
          Quince::Component::SELF_SELECTOR => String,
          **kw,
        )
      end

      def State(**kw)
        st = kw.empty? ? nil : Quince::Config.state_struct_type.new(**kw)
        self.const_set "State", st
      end

      def exposed(action, method: :POST)
        @exposed_actions ||= Set.new
        @exposed_actions.add action
        route = "/api/#{self.name}/#{action}"
        Quince::SinatraApp.create_route_handler(
          verb: method,
          route: route,
        ) do |bind|
          Thread.current[:request_binding] = bind
          params = bind.receiver.params
          Thread.current[:params] = params[:params] || {}
          instance = Quince::Serialiser.deserialise(CGI.unescapeHTML(params[:component]))
          if params[:rerender]
            instance.instance_variable_set :@state_container, params[:stateContainer]
            render_with = params[:rerender][:method].to_sym
          else
            render_with = :render
          end
          instance.instance_variable_set :@render_with, render_with
          instance.instance_variable_set :@callback_event, params[:event]
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
        if const.const_defined?("Props")
          const::Props.new(
            PARENT_SELECTOR_ATTR => id,
            **props,
            SELF_SELECTOR => id,
          )
        end
      end
    end

    extend Forwardable
    include Callback::ComponentHelpers

    attr_reader :props, :state, :children

    def render
      raise "not implemented"
    end

    protected

    def to(route, via: :POST)
      self.class.exposed route, method: via
    end

    def params
      Thread.current[:params]
    end

    def request_context
      Thread.current[:request_binding].receiver
    end

    def_delegators :request_context,
      :attachment, :request, :response, :redirect, :halt, :session, :cache_control, :send_file, :to, :status, :headers, :body

    private

    attr_reader :__id

    PARENT_SELECTOR_ATTR = :"data-quid-parent"
    SELF_SELECTOR = :"data-quid"

    def html_parent_selector
      "[#{PARENT_SELECTOR_ATTR}='#{__id}']".freeze
    end

    def html_self_selector
      "[#{SELF_SELECTOR}='#{props[SELF_SELECTOR]}']".freeze
    end
  end
end
