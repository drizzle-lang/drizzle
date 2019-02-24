module Drizzle
  module Object
    alias ObjectType = String

    abstract class Object
      @object_type : ObjectType

      abstract def inspect : String

      getter object_type
    end
  end
end
