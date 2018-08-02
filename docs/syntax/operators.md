---
title: Operators
layout: home
permalink: /syntax/operators/
---

# Operators

Some operators have different meanings when used either `infix` or `prefix` notation.

For example, the `-` operator when used in `infix` notation denotes subtraction (`2 - 1 # == 1`) whereas with `prefix` notation gives negation (`-1 # == -1`).

The operator meanings in the lists below are `infix` notation unless stated otherwise.

## Arithmetic
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

## Logic
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

## Other
- `=`
    - Assignment
        - `let x: int = 3`
- `->`
    - Return Type Identifier
        - `def test() -> int = return 3`
