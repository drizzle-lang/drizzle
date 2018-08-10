---
title: Datatypes
layout: home
permalink: /syntax/datatypes/
---

# Datatypes
Below is a list of all the different built in datatypes that are in my thoughts for Sapphire.

Some of them I am currently unsure about, but for the most part these types should be pretty set in stone.

## Any
- `any` is a special type that is used for type hinting collection type variables where the types of all the possible items in the collection is unknown.
- `list[any]` allows a list of any type objects (`list` also works).
- `tuple[any]` allows a tuple of any type objects (`tuple` also works).
- `dict[str, any]` is a dictionary with string keys and any type values.
- `dict[any, any]` allows both keys and values to be any *hashable* type (`dict` also works).
- `set[any]` is a set of any *hashable* type
- Please note that `any` only works for collection types. For now, I don't think like you should be allowed to declare an `any` type variable.

## Null
- `null` is a special variable that represents nothing.
- In cases where a variable can only be `null`, the variable can be typed with the `none` type
- If a variable can be `null` then the type must be suffixed with a `?` character, indicating that the variable is *nullable*.
    - `let a: list[int]  = null  # ERROR`
    - `let b: list[int]? = null  # OK`
- Return types can also be *nullable*.
    - `def f() -> str  = return null  # ERROR`
    - `def f() -> str? = return null  # OK`
- See the section on [Nullable Types](#nullable-types) for more information

## Nullable Types
- If a type declaration has a `?` suffix, then the type is considered *nullable* and can have `null` assigned to it.
- If a user tries to use a nullable type without checking for `null` values the interpreter will warn them.
- Nullables can be converted into their normal types by appending the `!` character to the variable name.
    - `let s: str? = 'abc'  # s is of type str?`
    - `s = s!  # now s is of type str`
- If the `!` is used when the value of a nullable is null, an error will be thrown
- You can check the value of a nullable by instead appending the `?` character.
    - This will return a boolean stating whether the value of the variable is null or not

```sapphire
let s: str? = null
# Here, s is of type `str?`
if s? {
    # Here we know s is not null, so s becomes the `str` type
}
else {
    # Here we know s is null, so s becomes the `none` type
}

let t: str? = 'abc'
# Type of t is `str?`
t = t!
# Type of t is now `str`
```

## Numerics
- `int`.
    - 64 bit integer.
- `float`.
    - 64 bit floating point number.
- `oct`
    - Octal number
- `hex`
    - Hexadecimal number
- `num` is a super type for all numeric types that can be used for param and return types in functions that can handle `int` and `float` types.
- Like Ruby / Crystal, the numeric types in `Sapphire` will have methods (`x: float = 3.as(float)`).
- Currently, I think we can just have a single `int` and `float` type for 64-bit integers and 64-bit floats for now.

## Strings
- `'Hello, World'`.
- String templating follows Ruby / Crystal style (`'We just converted #{x} into a float'`).
- For typing, `str` is used.

## Booleans
- `true`, `false`.
- For typing, `bool` is used.

## Lists
- `a: list[int]: [1, 2, 3]`
- `b: list: [1, 'abc', 3.1415]`
- Lists are mutable, like in Python
    - `b[0] = 2 # => OK`

## Tuples
- `c: tuple[int] = (1, 2, 3)`
- `d: tuple = (1, 'abc', 3.1415)`
- Tuples are immutable
    - `d[0] = 2 # => ERROR`

## Dictionaries
- `map: dict[str, str] = {'a': 'b', 'b': 'a'}`
- `map2: dict[str, any] = {'a': 'b', 'b': 2}`
- `map3: dict = {0: 'a', 'b': 1}`

## Sets
- `s1: set[int] = {1, 2, 3}`
- `s2: set = {1, 'b', 0xa}`

A big plus Sapphire has over Python in this regard is that, due to Sapphire's type declarations, the `{}` literal can be used to define empty sets **and** empty dicts with no hassle\*!

\* A small bit of hassle might arise when using the literal in a conditional (`if s == {}`) but hopefully the parser will be able to handle it.

## Ranges

Following a similar style to Crystal, ranges are defined in two ways;

- `0..5`
    - Contains the numbers from 0 to 5 inclusive (0, 1, 2, 3, 4, 5)
- `0...5`
    - Contains the numbers from 0 to 5 exclusive (0, 1, 2, 3, 4)

As a metaphor to remember this, you can imagine that adding the third dot pushes the 5 out of the range.

## Union Types

When something can be one of a select few types, e.g values in a `dict`, then they can by typed using union types.

Union types are simply a list of types separated by the `|` character.

For example, `dict[str, str | int]` is the type for a dictionary with string keys and either string or integer values.

## Functions

As Sapphire supports *higher order functions*, meaning that functions can be passed as parameters, then these functions need to have a type hinting syntax.

The syntax is as simple as possible, simply the types in the argument tuple, the return type operator and the return type, all contained in parentheses.

For example, `((num, num) -> num)` is the type for functions that take in two `num` type parameters and return a `num` type parameter.
