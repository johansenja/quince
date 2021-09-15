module Quince
  class Callback
    module ComponentHelpers
      protected

      DEFAULT_CALLBACK_OPTIONS = {
        prevent_default: false,
        take_form_values: false,
      # others could include:
      # debounce: false,
      }.freeze

      def callback(method_name, **opts)
        unless self.class.instance_variable_get(:@exposed_actions).member?(method_name)
          raise "The action you called is not exposed"
        end

        opts = DEFAULT_CALLBACK_OPTIONS.merge opts

        Callback.new(self, method_name, **opts)
      end
    end

    module Interface
      attr_reader :receiver, :method_name, :prevent_default, :take_form_values
    end

    include Interface

    def initialize(receiver, method_name, prevent_default:, take_form_values:)
      @receiver, @method_name = receiver, method_name
      @prevent_default = prevent_default
      @take_form_values = take_form_values
    end
  end
end
