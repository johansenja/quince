module Quince
  module Callback
    module ComponentHelpers
      protected

      def callback(method_name)
        unless self.class.instance_variable_get(:@exposed_actions).member?(method_name)
          raise "The action you called is not exposed"
        end

        Callback::Base.new(self, method_name)
      end
    end

    class Base
      attr_reader :receiver, :method_name

      def initialize(receiver, method_name)
        @receiver, @method_name = receiver, method_name
      end

      def render
        owner = receiver.class.name
        selector = receiver.send :html_element_selector
        internal = Quince::Serialiser.serialise(receiver)
        payload = { component: CGI.escapeHTML(internal) }.to_json
        CGI.escapeHTML(
          %Q{const p = #{payload}; callRemoteEndpoint(`/api/#{owner}/#{method_name}`, JSON.stringify(p),`#{selector}`)},
        )
      end
    end

    class WithFormValues < Base
      def render
        owner = receiver.class.name
        selector = receiver.send :html_element_selector
        internal = Quince::Serialiser.serialise(receiver)
        payload = { component: CGI.escapeHTML(internal) }.to_json
        CGI.escapeHTML(
          "const p = #{payload}; callRemoteEndpoint(`/api/#{owner}/#{method_name}`, JSON.stringify({...p, params: getFormValues(this)}), `#{selector}`); return false",
        )
      end
    end
  end
end
