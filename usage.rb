require 'trither'

def do_something_and_return_a_try(data)
  if data
    Try::Success.new('new_data')
  else
    Try::Failure.new('failed')
  end
end

def do_something_and_return_new_data(data)
  data + ' more data'
end

def some_risky_computation()
  1 / 0
end

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


def do_righty_stuff(right_data)
  right_data + ' more right data'
end

def do_lefty_stuff(left_data)
  left_data + ' more left data'
end

either = Either::Right.new('data')
  .right_map { |right_data| do_righty_stuff(right_data) }
  .left_map { |left_data| do_lefty_stuff(left_data) }

if either.right?
  do_righty_stuff(either.right)
else
  do_lefty_stuff(either.left)
end

# returns 'No greeting'
Option.make(nil).map { |s| s + ' world' }.fetch('No greeting')
# returns 'hello world'
Option.make('hello').map { |s| s + ' world' }.fetch('No greeting')
# returns 'No greeting'
Option.make(nil).map { |s| s + ' world' }.get_or_else { 'No greeting' }
# returns 'hello world'
Option.make('hello').map { |s| s + ' world' }.get_or_else { 'No greeting' }
# returns 'No greeting'
Option.make('hello').flat_map { |_x| Option.make(nil) }.fetch('No greeting')
