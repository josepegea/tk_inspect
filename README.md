# TkInspect

Provides a poor man's version of the GUI development environment
created for original Smalltalk systems, including a console (workspace
in Smalltalk), inspectors and a class browser.

It uses [TkComponent](http://github.com/josepegea/tk_component) to
create the UI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tk_inspect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tk_inspect

## Usage

Once added the gem to your project or global environment, you can
launch the graphic console using

    $ bundle exec tk_console

If you add
[tk_inspect_rails](http://github.com/josepegea/tk_inspect_rails) you
will also get some goodies for playing with Rails applications inside
the GUI playground.

**WARNING**: This is very much a work in progress. More documentation
to come!!

## Author

Josep Egea
  - <https://github.com/josepegea>
  - <https://www.josepegea.com/>

## Why this?

I feel that Ruby is a fantastic language for building and interacting
with GUI's.

It's expressive, flexible and easy to read. GUI's spend most of their
time waiting for user input, so the actual performance of the language
is not as important as the power it gives to the developer. To that
avail, Ruby is a great fit, a true successor of Smalltalk, which was
tightly integrated with a great GUI.

However, there's not much current GUI work in Ruby land. Most of
developments happen in server side code, APIs and, of course, Rails.

I started writing
[TkComponent](http://github.com/josepegea/tk_component) to make it
easier to build GUI applications with Ruby.

But the more I played with that, and the more I learned about the
Smalltalk systems they built in the 70s and 80s at Xerox's PARC, the
more I felt that Ruby could have that, too.

So I started experimenting and playing and TkInspect is what came out
of it.

This is still mostly experimentation, but I can see some useful
outcomes from it, that I'll try to investigate further.

If you feel the same, I wish you find TkInspect useful. If you want
to make it grow, your contributions will be quite welcome.

You can hear me talk more about these ideas in this talk I gave in the
[Madrid Ruby Users
Group](https://www.madridrb.com/topics/ruby-gui-apps-beautiful-inside-and-outside-914)
on January 2021.

- <https://vimeo.com/506750901>

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/josepegea/tk_inspect. This project is intended to
be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor
Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TkComponent project’s codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code
of
conduct](https://github.com/josepegea/tk_inspect/blob/master/CODE_OF_CONDUCT.md).
