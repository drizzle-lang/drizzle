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
const person = 'World'
let msg = 'Hello, #{to}'  # Creates a string 'Hello, World' through templating (some day in the far future)

if (4 > 3 and true is not false) {
    msg += '!'
}

def say(msg: string) -> string {
    println(msg)
    return 'Message was said'
}

say(msg)
```
