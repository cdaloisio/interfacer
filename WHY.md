= Why did I create Interfacer? =

I went to bed one night, deeply troubled by the fact that a lot of OO
design books were written about languages that had very different
capabilities to Ruby.

For example, there are a number of books that talk about coding to
interfaces, and in principle I agree, this is an excellent design
pattern, but you usually have a compiler like in Java or C++ that will
tell you if you've incorrectly used an interface. This feature is baked
into the language. Ruby is an interpreted language, and doesn't give you
this, so you have to write specs.

Here are some of the main reasons I wanted to write this library:

- I had a feeling that there must be a better way than writing specs to
  enforce design pattern properties.
- I can't always recall what the pattern is that I'm supposed to be
  working with, and what it's properties are.
- I find it hard to work with code lacking in consistency in implementations and tests.
- The amount of structural duplication for applying patterns disturbs me
  greatly.





= How does Interfacer help? =

- Declaring your interfaces and patterns via a DSL that enforces the
  properties at load time removes the need for structural testing in
  your test suite.
- Behaviour tests for your classes can still be created in testing as
  before. We are only dynamically generating classes, nothing more.
- Variations in patterns are systematically removed, and usually will
  force the programmer to re-evaluate their choice of abstraction before
  proceeding.
- The number of lines of code that you write will drop significantly.





= Caveats =

- Load time will be longer, but because they are just PORO I would
  exepect the difference to be tiny, even for a large codebase.
- It makes debugging harder if you have a structural bug with your
  interfaces.
