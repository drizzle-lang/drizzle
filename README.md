# ![drizzle banner](./img/banner.png)

Drizzle is my very own programming language, simultaneously developed as a language I would like to use and a never-ending source of things to learn.

## Name
This project was originally called *Sapphire*.
I decided to make an organisation for this project as it would surely consist of multiple projects and I really enjoy having projects grouped into Organisations.

However, when I tried to do so, I found that `sapphire` and `sapphire-lang` were both taken in terms of names, and there were a few programming language projects named *Sapphire* on GitHub.
So I felt I needed to change the name.

Being a fan of Pokémon, my first thought was *Kyogre*, the legendary from Pokémon Sapphire.
From there I thought of his ability *Drizzle*, which I thought was a nice name for my language considering I also love rain, so there you go!

(Also I already had made stickers of the logo so I had to stick with blue and stuff >.>)

## Goals
The goals of the project are (in some particular order):
- Create a language with a nice syntax that I would like to use.
- Constantly learn ways to improve the language.
- Learn about the kind of work that goes into developing production grade languages.
- Eventually get Drizzle to the point where it can interpret / compile itself.

## Project Details
- Written in Crystal.
    - Drizzle will work off of Crystal's GC.
    - If we decide to write the interpreter in Drizzle later, we'll then have to implement out own GC.
- Parser (will eventually be) generated using [ANTLR](http://www.antlr.org/) for Go and translated into Crystal (like the books I'll be using).
- Language will initially be interpreted, then will be compiled.
    - When the compiled version starts, the interpreted version will be archived to a protected branch.
- When language is mature enough, rewrite the interpreter, and later the compiler, in Drizzle.

## Extensions
Some basic extensions that I would like to see built in to the language itself;
- `drizzle docs`: Similar to how crystal generates documentation I would like to have Drizzle being able to parse code and generate doc pages
- `drizzle fmt`: Similar to tools like `gofmt` or `crystal tool format`, I would like it for Drizzle to have a built-in formatter (once we have a style guide in place)
- `drizzle deps`: When the language starts to grow, we would need to have some kind of dependency manager built in.
    - Since the name change to `drizzle`, I'm thinking maybe calling deps `drops`?

## Roadmap
Here's a basic roadmap for anyone who is interested in what's going on with this project;
- Write a basic (non-production) version of the interpreter in Crystal, using the [interpreter book](https://interpreterbook.com).
- Research and learn ANTLR4 and use it to generate a better parser.
    - ANTLR cannot generate Crystal code so instead I intend to have it generate Go code and translate it, like I am doing with the book.
- Once the [compiler book](https://compilerbook.com) is released, go through that and turn Drizzle into a compiled language.
- Get Drizzle to the point where it can replace it's Crystal interpreter.
- Get Drizzle to the point where it can replace it's Crystal compiler.
- Start trying to add on the extra Drizzle tools.
- Keep improving stuff.

## Contributing
This project is open to anyone who wants to learn anything about creating programming languages!

A goal for early stages is to keep documentation at a high enough quality that it will hopefully be easy to follow what's going on, but if not then please open an issue!

### Contributors
- [crnbrdrck](https://github.com/crnbrdrck): creator, designer, maintainer
