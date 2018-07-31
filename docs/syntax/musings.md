---
title: Syntax Thoughts and Ideas
layout: home
permalink: /syntax/musings/
---

# Musings
Here's just a list of thoughts I'm having about the language at the moment.

This is nothing definite, and as I start to cement ideas, they will be moved to their own sections in this section.

## Types

- `any`
    - `any` is a special type that is used for type hinting collection type variables where the types of all the possible items in the collection is unknown.
    - `list[any]` allows a list of any type objects (`list` also works).
    - `tuple[any]` allows a tuple of any type objects (`tuple` also works).
    - `dict[str, any]` is a dictionary with string keys and any type values.
    - `dict[any, any]` allows both keys and values to be any *hashable* type (`dict` also works).
- `Numeric Types`
    - `int`.
    - `float`.
    - `num` is a super type for both that can be used for param and return types in functions that can handle `int` and `float` types.
    - Like Ruby / Crystal, the numeric types in `Sapphire` will have methods (`x: float = 3.as(float)`).
    - Currently, I think we can just have a single `int` and `float` type for 64-bit integers and 64-bit floats for now.
- `String`
    - `"Hello, World"`.
    - String templating follows Ruby / Crystal style (`We just converted #{x} into a float`).
    - For typing, `str` is used.
- `Boolean`
    - `true`, `false`.
    - For typing, `bool` is used.
- `Lists`
    - `a: list[int]: [1, 2, 3]`
    - `b: list: [1, 'abc', 3.1415]`
    - Lists are mutable, like in Python
        - `b[0] = 2 # => OK`
- `Tuples`
    - `c: tuple[int] = (1, 2, 3)`
    - `d: tuple = (1, 'abc', 3.1415)`
    - Tuples are immutable
        - `d[0] = 2 # => ERROR`
- `Dicts`
    - `map: dict[str, str] = {'a': 'b', 'b': 'a'}`
    - `map2: dict[str, any] = {'a': 'b', 'b': 2}`
    - `map3: dict = {0: 'a', 'b': 1}`

## Operators

Some operators have different meanings when used either `infix` or `prefix` notation.

For example, the `-` operator when used in `infix` notation denotes subtraction (`2 - 1 # == 1`) whereas with `prefix` notation gives negation (`-1 # == -1`).

The operator meanings in the lists below are `infix` notation unless stated otherwise.

### Arithmetic Operators
- `+`
    - Addition (infix)
        - `1 + 2  # == 3`
    - Unary plus (prefix)
        - `+1`
- `-`
    - Subtraction (infix)
        - `2 - 1  # == 1`
    - Unary minus (prefix)
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

### Logical Operators
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

## Functions

Functions in Sapphire are defined using the `def` keyword.

```sapphire
def multiply_message(msg: str, times: int = 5):
    to_print = msg * times
    println(to_print)
```

Sapphire also supports simple one line functions;

```sapphire
def multiply_message(msg: str, times: int = 5): println(msg * times)
```
