module Quince
  class Callback
    module ComponentHelpers
      protected

      DEFAULT_CALLBACK_OPTIONS = {
        prevent_default: false,
        take_form_values: false,
        debounce_ms: nil,
        if: nil,
        debugger: false,
        rerender: nil,
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
      attr_reader(
        :receiver,
        :method_name,
        *ComponentHelpers::DEFAULT_CALLBACK_OPTIONS.keys,
      )
    end

    include Interface

    def initialize(
      receiver,
      method_name,
      **opts
    )
      @receiver, @method_name = receiver, method_name
      ComponentHelpers::DEFAULT_CALLBACK_OPTIONS.each_key do |opt|
        instance_variable_set :"@#{opt}", opts.fetch(opt)
      end
    end
  end
end
