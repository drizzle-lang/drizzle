---
title: Functions
layout: home
permalink: /syntax/functions/
---

# Functions

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

## Single Line Functions
Sapphire also supports simple one line functions;

```sapphire
def multiply_message(msg: str, times: int = 5) = println(msg * times)
```

## Return Types
Return types of the function are shown through the use of the `->` operator

```sapphire
def test() -> int = return 3
```

If no return type is explicitly described, the `null` type is assumed to be the return type.
The `null` type is returned from a function in 3 cases:
1. When there's no `return` statement in the function.
2. When there's an empty `return` statement in the function.
3. When `null` is explicitly returned from the function.
