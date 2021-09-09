module Quince
  module Types
    class Base; end

    # precompiled helper types
    OptionalString = Rbs("String | Quince::Types::Undefined").freeze
    OptionalBoolean = Rbs("true | false | Quince::Types::Undefined").freeze

    # no functional value for now, other than constants
    Undefined = Class.new(Base).new.freeze
    Any = Class.new(Base).new.freeze
  end
end
