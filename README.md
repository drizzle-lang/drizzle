![drizzle banner](https://raw.githubusercontent.com/drizzle-lang/drizzle/master/img/banner.png)

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

## Installation
With the release of the v0.1.0 beta, I thought it handy to put in some installation instructions.
Only installation from source works at the moment, although I may put Drizzle up on the AUR at the very least sometime soon.

1. Install [Crystal](https://crystal-lang.org/reference/installation/)
2. Clone this repo
3. Build the Drizzle binary using `shards build --release`
4. *Optional* Add the binary to your path using `install bin/drizzle ~/.bin`
5. Run the `drizzle` command anywhere to start a REPL environment, or use `drizzle file.drzl` to run the code contained in the file

## Goals
The goals of the project are (in some particular order):
- Create a language with a nice syntax that I would like to use.
- Constantly learn ways to improve the language.
- Learn about the kind of work that goes into developing production grade languages.
- Eventually get Drizzle to the point where it can interpret / compile itself.

### Notes
- It would be nice if the project could maintain a side-by-side interpreter and compiler so that drizzle could have a fully functional REPL environment built into the language, or maybe provide drizzle-interpreter as a separate package or something idk
- The more I go through the interpreter book, the more I realise that translating the ANTLR parser every time I add something new might not be worth the hassle.
    - However, if I can do it in a smart way, I should only have to translate the whole thing once, and figure out how to add stuff manually going forward in the same style to keep the benefits
- Could generate the parser in a different language and commit that to source control
- Then whenever I make updates, I do it in a separate branch and use the PR to update the Crystal version

## Contributing
This project is open to anyone who wants to learn anything about creating programming languages!

A goal for early stages is to keep documentation at a high enough quality that it will hopefully be easy to follow what's going on, but if not then please open an issue!

### Contributors
- [freyamade](https://github.com/freyamade): creator, designer, maintainer
