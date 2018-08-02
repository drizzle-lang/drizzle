---
title: Syntax Thoughts and Ideas
layout: home
permalink: /syntax/musings/
---

# Musings
Here's just a list of thoughts I'm having about the language at the moment.

This is nothing definite, and as I start to cement ideas, they will be moved to their own sections in this section.

## Contents
- [Types](#types)
    - [Any](#any)
    - [Null](#null)
    - [Nullable](#nullable-types)
    - [Numerics](#numerics)
    - [Strings](#strings)
    - [Lists](#lists)
    - [Tuples](#tuples)
    - [Dictionaries](#dictionaries)
    - [Sets](#sets)
- [Operators](#operators)
    - [Arithmetic](#arithmetic)
    - [Logic](#logic)
    - [Other](#other)
- [Functions](#functions)
- [Object Orientation](#oop)
    - [Instance Variables and Methods](#instance-variables-and-methods)
    - [Class Variables and Methods](#class-variables-and-methods)
    - [Abstract Classes and Methods](#abstract-classes-and-methods)

## Operators

Some operators have different meanings when used either `infix` or `prefix` notation.

For example, the `-` operator when used in `infix` notation denotes subtraction (`2 - 1 # == 1`) whereas with `prefix` notation gives negation (`-1 # == -1`).

The operator meanings in the lists below are `infix` notation unless stated otherwise.

### Arithmetic
- `+`
    - Addition (`infix`)
        - `1 + 2  # == 3`
    - Unary plus (`prefix`)
        - `+1`
- `-`
    - Subtraction (`infix`)
        - `2 - 1  # == 1`
    - Unary minus (`prefix`)
        - `-1`
- `*`
    - Multiplication
        - `2 * 3  # == 6`
- `/`
    - Division
        - `5 / 2  # == 2.5`
- `//`
    - Integer Division (convert to integer by dropping the floating point)
        - `5 // 2  # == 2`
- `%`
    - Modulo (remainder of a division)
        - `5 % 2  # == 1`

### Logic
- `==`
    - Equality
        - `1 == 1  # true`
- `!=`
    - Inequality
        - `1 != 1  # false`
- `is`
    - Object equality
    - While `==` will check if two objects have the same value, `is` will check if they are the exact same object (i.e. two variables reference the same object, etc.)
        - `true is true  # true`
- `not`
    - Logical NOT
        - `not false  # true`
- `and`
    - Logical AND
        - `true and 1 == 1  # true`
- `or`
    - Logical OR
        - `true or false  # true`
- `<`
    - Less Than
        - `2 < 3  # true`
    - Class Inheritance
        - `Dog < Animal`
- `>`
    - Greater Than
        - `2 > 3  # false`
- `<=`
    - Less Than or Equal To
        - `3 <= 3  # true`
- `>=`
    - Greater Than or Equal To
        - `3 >= 3  # true`

### Other
- `=`
    - Assignment
        - `let x: int = 3`
- `->`
    - Return Type Identifier
        - `def test() -> int = return 3`

## Functions

Functions in Sapphire are defined using the `def` keyword.

```sapphire
def multiply_message(msg: str, times: int = 5) {
    to_print = msg * times
    println(to_print)
}

# In this example we show that Sapphire supports default params
multiply_message('a')  # Prints 'aaaaa'
multiply_message('a', 3)  # Prints 'aaa'
```

Sapphire also supports simple one line functions;

```sapphire
def multiply_message(msg: str, times: int = 5) = println(msg * times)
```

Return types of the function are shown through the use of the `->` operator

```sapphire
def test() -> int = return 3
```

If no return type is explicitly described, the `null` type is assumed to be the return type.
The `null` type is returned from a function in 3 cases:
1. When there's no `return` statement in the function.
2. When there's an empty `return` statement in the function.
3. When `null` is explicitly returned from the function.

## OOP

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

### Instance Variables and Methods
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

### Class Variables and Methods
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

### Abstract Classes and Methods
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
