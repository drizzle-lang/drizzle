---
title: Language Credits
layout: home
permalink: /syntax/credits/
---

# Language Credits

In this section I would just like to go through the languages I have mentioned as inspirations, and give a small outline of what inspiration I have taken from them.

## Python
One of the biggest inspirations for Sapphire is Python. I love its easy-to-read syntax, and as such Sapphire uses `and`, `or` and `not` instead of the more common `&&`, `||` and `!`.

Also taken from Python, and also Swift a little bit, is the style of type declaration. In Python, type hinting is done in the format `x: int = 3` and I personally just prefer that over `int x = 3`, though I can't really explain why.

Return types in Python are hinted using the `->` operator, which I also really like.

A lot of the data-type names, specifically collection types, in Sapphire are inspired by Python. Sapphire has `list`, `tuple`, `dict`, `set`, etc.

## Crystal
Crystal also uses colons for type declarations, which helps cement my decision in using them as Crystal is another programming language I really enjoy using.

Also in Crystal (and Ruby) is a convention of using `?` and `!` characters as suffixes for function names to denote some meanings.

A `?` at the end of a function name indicates that the function returns a boolean.

A `!` at the end of a function name indicates, according to the Ruby documentation, that the method is potentially dangerous. This tends to mean that it performs something in place.
It is common for there to be pairs of methods, such as `.sort` and `.sort!` for arrays. Without the `!` character, the method will return a copy of the original array that was sorted, but with the `!`, the calling array will be modified internally instead.

I like both of these conventions and hope to adopt them into Sapphire also.

Also, I think that the Crystal / Ruby style of string formatting is one of the nicest I have ever seen, and so will be used in Sapphire also.

## Swift
Swift has a similar enough syntax to Python in the areas I have discussed in the Python section, with regards to type declarations especially.

However, Swift uses braces for blocks, which is opposed to both Python (with indentation) and Crystal (with `end`).

Part of me really prefers braces over indentation as a matter of preference, so I've decided to use them in Sapphire.
