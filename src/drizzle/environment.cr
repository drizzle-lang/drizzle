module Drizzle
  # A class that maintains the state of the interpreter (i.e variables and such)
  class Environment
    @store : Hash(String, Drizzle::Object::Object)

    def initialize
      @store = {} of String => Drizzle::Object::Object
    end

    def get(key : String) : Drizzle::Object::Object?
      return @store[key]?
    end

    def set(key : String, value : Drizzle::Object::Object)
      @store[key] = value
    end
  end
end
