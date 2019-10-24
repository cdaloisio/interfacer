= Why did I create Interfacer? =

I had recently read a number of books that introduced OO design patterns
as a way to think about problem solving. Many of these books used Java
and other statically typed languages with built in language features
which meant that these patterns took on a specific form leveraging the
abilities of the core language.

I was writing a fair amount of Ruby code in which I was not able to
precisely apply these patterns in a way that I could enforce as some of
the key language features were missing. I had mostly been writing tests
to ensure the properties of an shared pattern. I felt that there might
have been a better way to express this.

Here are some of the main reasons I wanted to write this library:

- I had a feeling that there must be a better way than writing specs to
  enforce the properties of a design pattern, either existing or newly
  created.
- I can't always recall what patterns might be applicable and what the
  properties of that pattern are.
- I find it difficult to work with code lacking in consistency in
  implementations and tests.
- The amount of duplication with slight alterations on core patterns was
  something that became difficult and hard to manage as application
  complexity increased.


= How does Interfacer help? =

- Declaring your interfaces and patterns via a DSL that enforces the
  properties at load time removes the need for structural testing in
  your test suite.
- Behaviour tests for your classes can still be created in testing as
  before. We are only dynamically generating classes, nothing more.
- Variations in patterns are systematically removed, and usually will
  force the programmer to re-evaluate their choice of abstraction before
  proceeding.


= Caveats =

- Patterns are a useful way to talk about design patterns as they emerge
  based on the problem you are trying to solve. I don't nessasarily
  think that you should design by patterns.
- The main issue with my naive approach in this space is that I didn't
  give a thought to composability of components as I was writing this
  library. Solving for this would prove difficult.

