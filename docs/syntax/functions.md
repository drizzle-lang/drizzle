---
title: Functions
layout: home
permalink: /syntax/functions/
---

# Functions

Functions in Drizzle are defined using the `def` keyword.

```drizzle
def multiply_message(msg: str, times: int = 5) {
    to_print = msg * times
    println(to_print)
}

# In this example we show that Drizzle supports default params
multiply_message('a')  # Prints 'aaaaa'
multiply_message('a', 3)  # Prints 'aaa'
```

## Single Line Functions
Drizzle also supports simple one line functions;

```drizzle
def multiply_message(msg: str, times: int = 5) = println(msg * times)
```

## Return Types
Return types of the function are shown through the use of the `->` operator

```drizzle
def test() -> int = return 3
```

If no return type is explicitly described, the `null` type is assumed to be the return type.
The `null` type is returned from a function in 3 cases:
1. When there's no `return` statement in the function.
2. When there's an empty `return` statement in the function.
3. When `null` is explicitly returned from the function.
