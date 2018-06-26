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
idk, maybe?
issue with that style is we'd have to give indentation importance.
alternatively use braces (easier to interpret) with english keywords (and, or, not vs &&, ||, !)

## Notes
- I completely intend to use Sapphire for my development of anything I can really, so I'll be pushing it's development forward out of necessity regardless of whether anybody else uses it :)
