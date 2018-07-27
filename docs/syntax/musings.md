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
    - `any` is a special type that is used for type hinting collection type variables where the types of all the possible items in the collection is unknown
    - `list[any]` allows a list of any type objects (`list` also works)
    - `tuple[any]` allows a tuple of any type objects (`tuple` also works)
    - `dict[str, any]` is a dictionary with string keys and any type values
    - `dict[any, any]` allows both keys and values to be any *hashable* type (`dict` also works)
- `Numeric Types`
    - `int`
    - `float`
    - `num` is a super type for both that can be used for param and return types in functions that can handle `int` and `float` types.
    - Like Ruby / Crystal, the numeric types in `Sapphire` will have methods (`x: float = 3.as(float)`).
    - Currently, I think we can just have a single `int` and `float` type for 64-bit integers and 64-bit floats for now.
- `String`
    - `"Hello, World"`
    - String templating follows Ruby / Crystal style (`We just converted #{x} into a float`).
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
