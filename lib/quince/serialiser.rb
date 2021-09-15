module Quince
  class Serialiser
    class << self
      def serialise(obj)
        Oj.dump(obj)
      end

      def deserialise(json)
        Oj.load(json)
      end
    end
  end
end
