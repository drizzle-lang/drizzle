# ![placeholder logo type image](https://dummyimage.com/600x400/002366/d4def6.png&text=Sapphire)

Sapphire is my very own programming language, simultaneously developed as a language I would like to use and a never-ending source of things to learn.

## Goals
The goals of the project are (in some particular order):
- Create a language with a nice syntax that I would like to use.
- Constantly learn ways to improve the language.
- Learn about the kind of work that goes into developing production grade languages.
- Eventually get Sapphire to the point where it can interpret / compile itself.

## Extensions
Some basic extensions that I would like to see built in to the language itself;
- `sapphire docs`: Similar to how crystal generates documentation I would like to have Sapphire being able to parse code and generate doc pages
- `sapphire fmt`: Similar to tools like `gofmt` or `crystal tool format`, I would like it for Sapphire to have a built-in formatter (once we have a style guide in place)
- `sapphire deps`: When the language starts to grow, we would need to have some kind of dependency manager built in.

## Roadmap
Here's a basic roadmap for anyone who is interested in what's going on with this project;
- [ ] Finish the interpreter book with [ked](https://github.com/crnbrdrck/ked).
- [ ] Learn enough C++ to get a start on the project.
- [ ] Go through the [interpreter book](https://interpreterbook.com) and get Sapphire up and running as far as that book goes.
- [ ] Once the [compiler book](https://compilerbook.com) is released, go through that and turn Sapphire into a compiled language.
- [ ] Get Sapphire to the point where it can replace it's C++ interpreter.
- [ ] Get Sapphire to the point where it can replace it's C++ compiler.
- [ ] Keep improving stuff

Although I'm currently not sure where in the list they should go, there should also be a point on developing the tools like `docs` and `fmt`.

## Syntax Idea
The syntax is inspired by a mix of Python, Swift and TypeScript, which ***hopefully*** leads to a nice looking syntax;

```sapphire
const person = 'World'
let msg = 'Hello, {{ to }}' // Creates a string 'Hello, World' through templating (some day in the far future)

if (4 > 3 and true is not false) {
    msg += '!'
}

def say(msg: string) -> string {
    println(msg)
    return 'Message was said'
}

say(msg)
```

## Contributing
This project is open to anyone who wants to learn anything about creating programming languages!

A goal for early stages is to keep documentation at a high enough quality that it will hopefully be easy to follow what's going on, but if not then please open an issue!
