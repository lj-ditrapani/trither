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

either = Either::Right.new('data')
  .right_map { |right_data| do_righty_stuff(right_data) }
  .left_map { |left_data| do_lefty_stuff(left_data) }

if either.right?
  do_something(either.right)
else
  do_something_else(either.left)
end

# returns 'fail'
Option.make(nil).map { |s| s + ' world' }.fetch('fail')
# returns 'hello world'
Option.make('hello').map { |s| s + ' world' }.fetch('fail')
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
