# Trither

Very simple implementations of Try, Either, and Option inspired by Scala


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
        If computation returs without raising an error => Success(result)

    Option.make(value)
        If value.nil? => None
        Else => Some(value)

Try (Success of Failure) methods

    failure?    Failure(error) => true
                Success(value) => false
    flat_map    Failure(error) => Failure(error)
                Success(value) => executes given block and returns result
    map         Failure(error) => Failure(error)
                Success(value) => executes given block & returns Success(result)
    fail_map    Failure(error) => executes given block & returns Failure(result)
                Success(value) => Success(value)
    get_or_else Success(value) => returns the value
                Failure(error) => executes given block and returns result

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
    fetch       None => returns default
                Some(value) => returns value
    flat_map    None => returns None
                Some(value) => executes given block
                               if block's result is nil => None
                               else => block's result
    map         None => returns None
                Some(value) => executes given block and wraps result in Option
    get_or_else None => executes given block and returns result
                Some(value) => returns value


## Usage

```ruby
require 'trither'

try = Try::Success.new('data')
another_try = try.flat_map do |data|
  do_something_and_return_a_try(data)
end
a_3rd_try = another_try.map do |data|
  do_something_and_return_new_data(data)
end
result = a_3rd_try.get_or_else do |error|
  handle_error(error)
end
# Can also use factory method
try = Try.make { some_risky_computation() }

either = Either::Right.new('data')
  .right_map { |right_data| do_righty_stuff(right_data) }
  .left_map { |left_data| do_lefty_stuff(left_data) }

if either.right?
  do_something(either.right)
else
  do_something_else(either.left)
end

# returns 'No greeting'
Option.make(nil).map { |s| s + ' world' }.fetch('No greeting')
# returns 'hello world'
Option.make('hello').map { |s| s + ' world' }.fetch('No greeting')
# returns 'No greeting'
Option.make(nil).map { |s| s + ' world' }.get_or_else { 'No greeting' }
# returns 'hello world'
Option.make('hello').map { |s| s + ' world' }.get_or_else { 'No greeting' }
```


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lj-ditrapani/trither.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## TODO

Possibly add filter to Try & Option
- Use cases:
  - Try: convert Success to Failure unless condition is met
  - Option: convert Some to None unless condition is met
- Not sure if the use cases are that useful

Possibly add `flat_map` to Either (`right_flat_map` & `left_flat_map`)
- Use case:  If you have an operation on an either that returns another either
- Not sure if the use case is that useful
- Makes it more monadic

Possibly add `empty_map` or `none_map` to Option
- Some(x) => Some(x)
- None => yield block()
