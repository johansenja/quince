# Quince

### What is Quince?

Quince is an opinionated framework for building dynamic yet fully server-rendered web apps, with little to no JavaScript.

### Inspired by

React, Turbo, Hotwire amongst others

### Current status

Proof of concept, but [working in production](https://quince-rb.herokuapp.com/), and with decent performance despite few optimisations at this stage

### How it works

- Define some components and `expose` them at certain routes
- Define some interactions that can take place, which can change the state of the components, and are handled with ruby methods
- The front end will swap out the updated components with new HTML re-rendered by the back end

## Minimal 'hello world' example

```ruby
# app.rb
require "quince_sinatra"

class App < Quince::Component
    def render
      html(
        head,
        body("hello world")
      )
    end
end

expose App, at: "/"
```

- Run it via
```sh
ruby app.rb
```

- Visit `localhost:4567/`!

## More complex example

```ruby
require 'quince_sinatra'

class App < Quince::Component
    def render
      Layout(title: "First app") {[
        Counter()
      ]}
    end
end

class Layout < Quince::Component
  Props(title: String)
  
  def render
      html(
        head(
            internal_scripts
        ),
        body(
            h1(props.title),
            children
        )
      )
  end
end

class Counter < Quince::Component
    State(val: Integer)
    
    self.initial_state = {
        val: 0,
    }
    
    exposed def increment
        state.val += 1
    end
    
    exposed def decrement
        state.val -= 1
    end
    
    def render
        div(
            h2("count is #{state.val}"),
            button(onclick: method(:increment)) { "++" },
            button(onclick: method(:decrement)) { "--" }
        )
    end
end

expose App, at: "/"
```

#### See https://github.com/johansenja/quince-demo and https://quince-rb.herokuapp.com/ for more

## Why Quince?

### Why not?

- You have pre-existing APIs which you want to integrate a front end with
- You want to share the back end API with a different service
- You want more offline functionality
- You need a super complex/custom front end

### Why?

- Lightweight 🪶
    - Very few dependencies
    - Just a couple hundred lines of core logic
    - Fewer than 30 lines (unminified) of JavaScript in the front end
- Plug and play into multiple back ends 🔌
- Components > templates 🧩
    - Write html-like elements, but with strong typo resistence 
    - no special syntax or compilation required
- Shallow learning curve if you are already familiar with React 📈
- Just worry about your core business logic and how the app looks 🧪
    - No need to worry about
        - routes
        - controllers
        - front end -> back end communication/APIs/Data transfer
        - front end -> back end code sharing
    - Quince handles these for you
- No node_modules 📦
    - No yarn/npm
    - Minimise bundle size concerns
    - Manage your dependencies just using bundler & rubygems
    - Make use of other pre-built Quince components via rubygems
- Get full use of Ruby's rich and comprehensive standard library 💎
- Take advantage of Ruby's ability to wrap native libraries (eg. gems using C) ⚡️
- Fully server-rendered responses 📡
    - Single source of truth for your app's code (no code-sharing needed)
    - Better SEO out the box
    - Know exactly what your user is seeing
        - Tracking a user's activity on the front end has become a big deal, especially in heavily front-end driven apps/SPAs, in order to be able to see how a user is actually using the app (ie. to track how the state has been changing on the front end)
        - This normally requires cookies and a premium third party service
        - But if everything a user sees is generated server-side, it would be easy to reconstruct a user's journey and their state changes

## Installation

Quince itself is framework agnostic, so you should use an adaptor which plugs it into an existing framework for handling basic server needs

### Install it via adapters

- [Sinatra](https://github.com/johansenja/quince_sinatra)

Pick one, and add it to your application's Gemfile, eg:

```ruby
gem 'quince_sinatra'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install quince_sinatra


## Usage notes

- All HTML tags are available via a method of the same name, eg. `div()`, `section()`, `span()` - **with the exception of `para` standing in for `p` to avoid clashes with Ruby's common `Kernel#p` method**
- All HTML attributes are available, and are the same as they would be in a regular html document, eg. `onclick` rather than `onClick` - **with the exception of a `Class`, `Max`, `Min`, `Method`** - which start with capital letters to avoid clashes with some internal methods.
- Type checking is available at runtime for a component's `State` and `Props`, and is done in accordance with [Typed Struct](https://github.com/johansenja/typed_struct)
- Children can be specified in one of two places, depending on what you would prefer:
    -  as a block argument, to maintain similar readability with real html elements, where attributes come first
        ```ruby
        div(id: :my_div, style: "color: red") { h1("Single child") }
        div(id: "div2", style: "color: green") {[
            h2("multiple"),
            h3("children")
        ]}
        ```
    -  as positional arguments (for convenience and cleanliness when no props are passed)
        ```ruby
        div(
            h1("hello world")
        )
        ```
- A component's `render` method should always return a single top level element, ie. if you wanted to return 2 elements you should wrap them in a `div`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johansenja/quince.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
