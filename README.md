# Drizzle

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

## Extensions
Some basic extensions that I would like to see built in to the language itself;
- `drizzle docs`: Similar to how crystal generates documentation I would like to have Drizzle being able to parse code and generate doc pages
- `drizzle fmt`: Similar to tools like `gofmt` or `crystal tool format`, I would like it for Drizzle to have a built-in formatter (once we have a style guide in place)
- `drizzle drops`: When the language starts to grow, we would need to have some kind of dependency manager built in. Dependencies will be called `drops`
- `drizzle playground`: Seems to be a common thing nowadays, so drizzle could do with one

## Roadmap
Here's a basic roadmap for anyone who is interested in what's going on with this project;

- [ ] Interpreter written in Crystal (using https://interpreterbook.com)
    - [x] Chapter 1 (Lexing)
    - [x] Chapter 2 (Parsing)
    - [ ] Chapter 3 (Evaluating)
    - [ ] Chapter 4 (Extending the Interpreter)
    - [ ] Chapter 5 (Macro System)
- [ ] Minor Extras before improving the language again
    - [ ] Move docs to using [Gitbook](https://www.gitbook.com/?t=2) and make it more in depth / finalize initial languge design
    - [ ] Improve the syntax definition file and convert it into .tmLanguage
    - [ ] Extend interpreter so that initial design works
    - [ ] Do a simple POC project in Drizzle to show that it does actually work
- [ ] ANTLR Generated Parser
    - [ ] Write (E)BNF notation for Drizzle
    - [ ] Ensure the generated Parser works as intended
    - [ ] Convert parser to Crystal (probably from Go or Python)
        - Alternatively, look at writing a Crystal generator for ANTLR to avoid this step
- [ ] Compiler written in Crystal (using https://compilerbook.com)
    - [ ] Chapter  1 (Compilers & VMs)
    - [ ] Chapter  2 (Hello Bytecode)
    - [ ] Chapter  3 (Compiling Expressions)
    - [ ] Chapter  4 (Conditionals)
    - [ ] Chapter  5 (Keeping Track of Names)
    - [ ] Chapter  6 (String, Array and Hash)
    - [ ] Chapter  7 (Functions)
    - [ ] Chapter  8 (Built-in Functions)
    - [ ] Chapter  9 (Closures)
    - [ ] Chapter 10 (Taking Time)
- [ ] Plans for after in no particular order;
    - [ ] Self host the interpreter
    - [ ] Self host the compiler
    - [ ] Move the compiler to LLVM
    - [ ] Add on extra tools
    - [ ] Extend the drizzle stdlib
    - [ ] Give repositories for installation instead of doing it from source with Crystal

### Notes
- It would be nice if the project could maintain a side-by-side interpreter and compiler so that drizzle could have a fully functional REPL environment built into the language, or maybe provide drizzle-interpreter as a separate package or something idk
- The more I go through the interpreter book, the more I realise that translating the ANTLR parser every time I add something new might not be worth the hassle.
    - However, if I can do it in a smart way, I should only have to translate the whole thing once, and figure out how to add stuff manually going forward in the same style to keep the benefits

## Contributing
This project is open to anyone who wants to learn anything about creating programming languages!

A goal for early stages is to keep documentation at a high enough quality that it will hopefully be easy to follow what's going on, but if not then please open an issue!

### Contributors
- [crnbrdrck](https://github.com/crnbrdrck): creator, designer, maintainer
