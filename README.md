# Sapphire

`.sph`

![placeholder logo type image](https://dummyimage.com/600x400/002366/d4def6.png&text=Sapphire)

A placeholder repository for my very own programming language, for when I eventually get around to it :]

Not really sure what I want it to do, or look like, but after working on [ked](https://github.com/crnbrdrck/ked) I've gotten a hankering to start my own programming language for the fun of it! 

Join in the adventure if you want to :heart:

## Thought Dump
- Maybe a compiled language? (https://compilerbook.com/)
    - That book follows on from where the interpreter one leaves off so maybe start with an interpreted language?
    - Hopefully we could set it up that the Sapphire interpreter / compiler will eventually be written in sapphire
    - Could use this language as an excuse to learn something like C++?
    - The compiler book builds its own VM, but maybe Sapphire could run on the LLVM for cross compatibility?
- I think I might write the interpreter in Go up until the point where Sapphire is feature complete enough that it could interpret itself
    - When I start the Sapphire version of the interpreter, backup the Go interpreter to a separate branch that we can use to start writing a compiler
- Easy to read syntax (one of the reasons I love Python / Crystal so much)
- Maybe get a feel for the good parts of a few languages and try to add them into Sapphire without compromising on anything

These are lofty (probably too lofty for just me right now) goals but damnit I'm gonna have a good try off it!

## Language Ideas

```sapphire
const to = 'world'
let msg = 'hello, {{to}}!'

if (4 > 3 and true is not false) {
  msg += ' what a great day'
}

def say(msg: string) -> string {
  println(msg)
  return 'goodbye'
}
```
I honestly do like braces over indentation (also they're easier to interpret >.>)  but I also like the english-y nature of Python's syntax so I also want to include examples of that.

## Notes
- I completely intend to use Sapphire for my development of anything I can really, so I'll be pushing it's development forward out of necessity regardless of whether anybody else uses it :)
- I also intend to write many blog posts about the development of Sapphire and keep the source code as open and easy to read as possible so that anyone can help out!

## Logo
I have an idea for a logo but I don't know if I'll be able to make it but I'll try;
- A lineart vector image of a teardrop shaped sapphire in #002366 (the language color), but nice looking idk
