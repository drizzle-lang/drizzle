---
title: Classes
layout: home
permalink: /syntax/classes/
---

# Classes

Classes in Sapphire are denoted by the `class` keyword.
Inheritance uses the `<` operator.

```sapphire
class Dog < Animal {}
```

The constuctor in Sapphire is an instance function called `init`.

```sapphire
class Person {
    name: str
    age: int

    def init(name: str, age: int = 0) {
        self.name = name
        self.age = age
    }
}

let p1 = Person('Sapphire')
let p2 = Person('Sapphire', 5)
```

By default, an empty constructor is defined that takes no parameters and does nothing other than creates the instance for the user.

## Instance Variables and Methods
Instance variables and methods are created simply by declaring them within the scope of the class itself

```sapphire
class Dog < Animal {
    noise: str = 'Bark!'
    def make_noise() -> str {
        return self.noise
    }
}
```

`self` is used to explicitly access instance variables or methods.
Unlike Python, `self` does not have to be provided as a parameter.

## Class Variables and Methods
The `static` keyword is used to denote class variables or methods

```sapphire
class Dog < Animal {
    static noise: str = 'Bark!'
    static def make_noise() -> str {
        return self.noise
    }
}
```

The `self` keyword can be used to access both class and instance methods and variables.

## Abstract Classes and Methods
The `abstract` keyword can be used as a modifier on both `class` and `def` keywords to create abstract classes and functions.

Abstract classes are classes that can not be instantiated by themselves, and abstract methods are methods that do not have a definition.

When an abstract class is inherited by a concrete class, all abstract methods need to be defined or the code will not run.

```sapphire
abstract class Animal {
    abstract def make_noise() -> str

    # Abstract classes can also contain concrete definitions
    def is_animal?() -> bool = return true
}

let a: Animal = Animal()  # Causes an error as abstract classes cannot be instantiated

class Dog < Animal {}  # Causes an error as not all abstract functions are defined

class Cat < Animal {
    def make_noise() = return 'Meow!'
}  # Valid definition as it fully defines all abstract methods

let b: Animal = Cat()  # Valid as `Cat` is a concrete class that is a subclass of Animal
```
