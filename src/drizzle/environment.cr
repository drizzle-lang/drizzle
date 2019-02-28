module Drizzle
  # A class that maintains the state of the interpreter (i.e variables and such)
  class Environment
    @store : Hash(String, Drizzle::Object::Object)
    @outer : Environment?

    def initialize(@outer = nil)
      @store = {} of String => Drizzle::Object::Object
    end

    def get(key : String) : Drizzle::Object::Object?
      val = @store[key]?
      if val.nil? && !@outer.nil?
        return @outer.not_nil!.get key
      end
      return val
    end

    def set(key : String, value : Drizzle::Object::Object)
      @store[key] = value
    end
  end
end
