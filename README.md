# Sheaf

Immutable, composable, multi-purpose middleware stack for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sheaf'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install sheaf
```

Inside of your Ruby program, require Sheaf with:

```ruby
require 'sheaf'
```

## Usage

First of all, let's save us some typing:

```ruby
include Sheaf
```

Using `Sheaf::Stack` is similar to other Ruby middleware
implementations. In fact, any Object that responde to `#call` can be
added to the stack:

```ruby
class MyMiddleware
  def call(n)
    yield n + 2
  end
end

stack = Stack.new(MyMiddleware.new)

# A (optional) block can be passed to #call to capture the result.
stack.call(40) do |result|
  result
end
# => 42
```

Stacks can nested:

```ruby
stack_a = Stack.new(MyMiddleware.new)
stack_b = Stack.new(MyMiddleware.new).add(stack_a)

stack_b.call(38) do |result|
  result
end
# => 42
```

Note that calling `Stack#add` will always return a new `Stack`:

```ruby
stack_a = Stack.new(MyMiddleware)
stack_b = stack_a.add(MyMiddleware)

stack_b.to_a
# => [MyMiddleware, MyMiddleware]

stack_a.to_a
# => [MyMiddleware]
```

Stacks implement `Enumerable` and also respond to `#fmap`, which will
returns a new Stack:

```ruby
stack = Stack[MyMiddleware, MyMiddleware]

stack.fmap(&:new).call(38) do |result|
  result
end
# => 42
```

`Sheaf::Stack` also gives you a more traditional, block-based DSL to
build your stacks:

```ruby
stack = Stack.build do
  add MyMiddleware
end

stack.fmap(&:new).call(40) do |result|
  result
end
# => 42
```

## License

Copyright 2014-2015 Tobias Svensson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

