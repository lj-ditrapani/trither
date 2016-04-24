# Trither

Very simple implementations of Try and Either inspired by Scala


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

    try = Try::Success('data')
    another_try = try.then do |data|
      do_something_and_return_a_try(data)
    end
    result = another_try.on_failure do |error|
      handle_error(error)
    end
    result.unwrap

    either = Either::Right.new('data')
    if either.right?
      do_something(either.right)
    end


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lj-ditrapani/trither.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

