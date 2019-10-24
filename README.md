# Interfacer

## THIS PROJECT IS AN EXPERIMENT ONLY FOR LEARNING PURPOSES AND IS NOT ACTIVELY MAINTAINED. DO USE IN PRODUCTION ##

Interfacer is collection of biased, enforcable OO design
patterns that you can implement in your code using a DSL.

Read more on [why](WHY.md) I started working on Interfacer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interfacer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interfacer

## Usage

```ruby
# Here's an example using the Adapter DSL.

# You want to check if something fits.

class RoundHole
  def initialize(radius)
    @radius = radius
  end

  def fits(peg)
    @radius >= peg.radius
  end
end

# Let's start of with two classes - SquarePeg and RoundPeg

class SquarePeg
  def initialize(width)
    @width = width
  end

  def width
    @width
  end
end

class RoundPeg
  def initialize(radius)
    @radius = radius
  end

  def radius
    @radius
  end
end

# Now you want to put the SquarePeg into the RoundPeg.
# Here's what happens at the moment.

round_hole = RoundHole.new(10)
square_peg = SquarePeg.new(5)
round_hole.fits(square_peg)
=> NoMethodError (undefined method `radius` for #<SquarePeg:0x9187293812308132 @width=10>)

# How can we fix this? First create an interface.

include Interfacer

Interface.build(:round_peg) do
  def_public_methods(:radius)
end

# This creates a `RoundPegInterface` class.

# Then create an adapter.

Adapter.build(:round_peg, with_interface: :round_peg, for_class: :square_peg) do
  radius do
    @square_peg.width * Math.sqrt(2) / 2
  end
end

# This creates a `SquarePegToRoundPegAdapter` class.
# And then...

round_hole = RoundHole.new(10)
square_peg = SquarePeg.new(5)
round_hole.fits(SquarePegToRoundPegAdapter.new(square_peg))
=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

This project is not actively maintained and is not accepting
contributions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
