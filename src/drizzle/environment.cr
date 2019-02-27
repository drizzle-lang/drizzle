module Drizzle
  # A class that maintains the state of the interpreter (i.e variables and such)
  class Environment
    @store : Hash(String, Object)

    def initialize
      @store = {} of String => Drizzle::Object
    end

    def get(key : String) : Drizzle::Object?
      return @store[key]?
    end

    def set(key : String, value : Drizzle::Object)
      @store[key] = value
    end
  end
end
