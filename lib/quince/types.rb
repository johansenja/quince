module Quince
  module Types
    # precompiled helper types
    OptionalString = Rbs("String?").freeze
    OptionalBoolean = Rbs("true | false | nil").freeze
    Any = Rbs("untyped").freeze
  end
end
