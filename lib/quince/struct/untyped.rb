module Quince
  class Struct < ::Struct
    def self.new(**attrs)
      super *attrs.keys, keyword_init: true
    end
  end
end
