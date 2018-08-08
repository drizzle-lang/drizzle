---
title: Control Statements
layout: home
permalink: /syntax/control/
---

# Control Statements

Control statements in Sapphire include the following;

- `if`
- `elif`
- `else`
- `for`
- `while`
- `break`
- `continue`

Before we go into the details, we first need to discuss what Sapphire treats as truthy and falsey.

## Truthy / Falsey

A `truthy` value is a value that translates to `true` in the case of conditional statements like `if` and `while`.

A `falsey` value is a value that translates to `false` in the same situations.

A `falsey` value is anything that is empty or represents nothing, which includes;
- `0`
- `false`
- `''  # empty string`
- `[]  # empty list`
- `()  # empty tuple`
- `{}  # empty set`
- `{:}  # empty dict (have to have the colon when not type hinted)`
- `null`

A value is `truthy` if it is not one of the above values.

## Conditionals

The simplest conditional is a solitary `if` statement.

These can be followed by any number of `elif` (else if) statements, and can also optionally be concluded with an `else` statement.

The syntax of these is as follows;

```sapphire
if false {
    println('False is a truthy value')
}
elif true {
    println('True is a truthy value')
}
else {
    println('This shouldn\'t really have happened...')
}
```

The `if` and `elif` statements take an expression, which is evaluated to be `truthy` or `falsey`.
If the expression for the statement evaluates as `truthy`, the contents of the following block are run.
If not, the next `elif` statement (if any) is run, which also takes an expression.
If none of the `elif` statements' expressions evaluate to a truthy value, the `else` block (if any) will be run.

Similar to Python, `if` statements can be used as part of assignment statements, like the following;

```sapphire
let x: int = if false { 3 } else { 4 }  # x == 4
```

In these situations, they are named `conditional expressions` instead of statements, due to the difference in definition between a statement and an expression.

## Loops

There are two types of looping in Sapphire; `for` and `while`.

`for` loops are used when the number of repetitions are known in advance, e.g. to do something 5 times, you can use the following code;

```sapphire
for i: int in 0...5 {
    println(i)
}
```
See more on `ranges` in the [Datatypes](/syntax/datatypes/#ranges) page.

The same output can be generated from the following;

```sapphire
for i: int in [0, 1, 2, 3, 4] {
    println(i)
}
```

The output of this will be
```sapphire
0
1
2
3
4
```

On the other hand, `while` loops are used when you don't know the amount of repetitions that will need to be done, e.g. when you're reading lines from a file and you don't know how many lines are in the file.

`while` loops take an expression, and if it evaluates to a `truthy` value, the block of the loop will be run.

```sapphire
let i: int = 0
while i < 10 {
    i++
}
```

## Break / Continue

There are two loop specific control statements in Sapphire; `break` and `continue`.

`break` when used inside a loop will stop the execution of the loop and continue execution of the program after the block of the loop.

`continue` when used will stop the execution of the current loop and continue from the next loop.
