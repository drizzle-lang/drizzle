---
title: Syntax
layout: home
permalink: /syntax/
---

# Syntax
Sapphire's source code can can be written in anything up to Unicode, due to Crystal's ability to handle Unicode codepoints in it's `char` type.

The language is currently in an initial design phase, so all the docs in this section are subject to change at will until the implementation begins.

## Example
Here is a brief example of the Sapphire code as it is currently planned to look.

If any specifics change in this section that affect this example, the example will also be updated.
```sapphire
# Also allows double quote strings

# Function definitions
# `num` is a type alias that allows both int and float types to be used
def add(a: num, b: num) -> num {
    return a + b
}

# Fibonacci function
def fibonacci(x: int) -> int {
    if (x == 0) {
        return 0
    }
    elsif (x == 1) {
        return 1
    }
    else {
        return fibonacci(x - 1) + fibonacci(x - 2)
    }
}

# Sapphire supports higher order functions, i.e. functions that take other functions as parameters
def run_twice(f: ((num) -> num), x: num) -> num {
    return f(f(x))
}

def add_two(x: num) {
    return x + 2
}

println(run_twice(add_two, 2)))  # Should print '6'

```

## Contents
Here's a little breakdown of the contents of this documentation section;

- [Datatypes](./datatypes/)
    - [Any](./datatypes/#any)
    - [Null](./datatypes/#null)
    - [Nullable](./datatypes/#nullable-types)
    - [Numerics](./datatypes/#numerics)
    - [Strings](./datatypes/#strings)
    - [Lists](./datatypes/#lists)
    - [Tuples](./datatypes/#tuples)
    - [Dictionaries](./datatypes/#dictionaries)
    - [Sets](./datatypes/#sets)
    - [Ranges](./datatypes/#ranges)
- [Operators](./operators/)
    - [Arithmetic](./operators/#arithmetic)
    - [Logic](./operators/#logic)
    - [Other](./operators/#other)
- [Control Statements](./control/)
    - [Truthy / Falsey Values](./control/#truthy--falsey)
    - [Conditionals](./control/#conditionals)
    - [Loops](./control/#loops)
    - [Break / Continue Statements](./control/#break--continue)
- [Functions](./functions/)
    - [Single Line Functions](./functions/#single-line-functions)
    - [Return Types](./functions/#return-types)
- [Classes](./classes/)
    - [Instance Variables and Methods](./classes/#instance-variables-and-methods)
    - [Class Variables and Methods](./classes/#class-variables-and-methods)
    - [Abstract Classes and Methods](./classes/#abstract-classes-and-methods)
