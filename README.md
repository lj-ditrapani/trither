# Trither

Very simple implementations of Try, Either, and Option inspired by Scala.
Depends on [contracts.ruby](https://egonschiele.github.io/contracts.ruby/).
Disable contracts in production by setting
the NO_CONTRACTS environment variable.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trither'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trither


## API

Factory methods

    Try.make { computation }
        If computation raises an error => Failure(error)
        If computation returns without raising an error => Success(result)

    Option.make(value)
        If value.nil? => None
        Else => Some(value)

Try (Success of Failure) methods

    failure?    Failure(error) => true
                Success(value) => false
    filter      Failure(error) => Failure(error)
                Success(value) => executes given block
                                  if block's result is true => Success(value)
                                  else => Failure(None)
    flat_map    Failure(error) => Failure(error)
                Success(value) => executes given block and returns result
    map         Failure(error) => Failure(error)
                Success(value) => executes given block & returns Success(result)
    fail_map    Failure(error) => executes given block & returns Failure(result)
                Success(value) => Success(value)
    or_else     Failure(error) => executes given block and returns result
                Success(value) => Success(value)
    get_or_else Failure(error) => executes given block and returns result
                Success(value) => returns the value

Either (Left or Right) methods

    left?       Left(value) => true
                Right(value) => false
    right?      Left(value) => false
                Right(value) => true
    left        returns value; defined on Left only
    right       returns value; defined on Right only
    left_map    Left(value) => executes given block and returns Left(result)
                Right(value) => Right(value)
    right_map   Left(value) => Left(value)
                Right(value) => executes given block and returns Right(result)

Option (Some or None) methods

    empty?      None => true
                Some(value) => false
    filter      None => None
                Some(value) => executes given block
                               if block's result is true => Some(value)
                               else => None
    fetch       None => returns default
                Some(value) => returns value
    flat_map    None => returns None
                Some(value) => executes given block
                               if block's result is nil => None
                               else => block's result
    map         None => returns None
                Some(value) => executes given block and wraps result in Option
    or_else     None => executes given blocke and returns result
                Some(value) => returns Some(value)
    get_or_else None => executes given block and returns result
                Some(value) => returns value


## Usage

See [usage.rb](usage.rb).


## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/lj-ditrapani/trither.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).


## TODO
Add any & flatten to option
all(seq(option)) -> option[seq[T]] & flatten(seq[option[T]]) -> seq[T]

Possibly add `empty_map` or `none_map` to Option
- Some(x) => Some(x)
- None => Try.make(yield block())

ADT?
