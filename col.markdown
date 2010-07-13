---
layout: default
title: Col
---

# Col

* This list will contain the table of contents
{:toc}

## Name

Col -- high-level console color formatting

## Synopsis

    require 'col'

    puts Col("Hello world!").red.bold
    puts Col("Hello world!").rb
    puts Col("Hello world!").fmt :red, :bold
    puts Col("Hello world!").fmt :rb

    puts Col("Hello ", "world!").fmt :red, :green
    puts Col("Hello ", "world!").fmt "r,g"

    puts Col("Hello ", "world!").fmt [:red, :bold], [:green, :bold]
    puts Col("Hello ", "world!").fmt "rb,gb"

    puts Col("Hello ", "world!").fmt [:bold], [:cyan, :italic, :on_white]
    puts Col("Hello ", "world!").fmt "_b,ciow"

    puts Col("Hello ", "world!").fmt [:blue, :on_yellow], [:on_green]
    puts Col("Hello ", "world!").fmt "b_oy,__og"


## Installation

    $ [sudo] gem install col

Source-code access is via Github.  See 

## Description

Col offers high-level access to the ANSI codes used to create colorful output on
the console.  It is optimised for dealing with multiple strings at once,
applying different color formatting to each string.  It does not add any methods
to the String class.

If formatting a single string, you can send the method names directly, or use
their abbreviation if applicable:

    puts Col("Hello world!").red.bold.on_white
    puts Col("Hello world!").rbow

    puts Col("Hello world!").bold.italic.strikethrough
    # No abbreviation for this

If formatting multiple strings, you are limited to using the `fmt` method.

    puts Col("Hello ", "world!").fmt [:red, :bold], [:green, :bold]
    puts Col("Hello ", "world!").fmt :rb, :gb
    puts Col("Hello ", "world!").fmt "rb,rg"

    puts Col("Hello ", "world!").fmt [:italic, :underline], [:green, :on_white]
    # No abbreviation for [:italic, :underline]

Abbreviations are available if the format you wish to use comprises:
* at most one foreground color
* at most one style
* at most one background color

See [Abbreviations](#abbreviations) below for details.


### Classes, methods, return values

`Col(...)` and `Col\[...]` create a `Col` object, whose only interesting methods are
`fmt` (to apply formatting) and `to_s`.  Any other method will be interpreted as
a format specifier.

`Col#fmt` returns a `String`:

    Col("string").fmt :red, :bold, :on_white    # -> String
    Col("string").fmt "rbow"                    # -> String
    Col("string").fmt :rbow                     # -> String

Directly-applied formatting methods return a `Col` object:

    Col("string").red                           # -> Col
    Col("string").red.bold                      # -> Col
    Col("string").red.bold.underscore.italic    # -> Col

Because `Col#to_s` is implemented, you can use `puts` directly:

    puts Col("string").red.bold

Directly-applied _abbreviated_ formatting methods return a `String`:

    Col("string").rbow                          # -> String
      # internally converted to
      #   Col("string).fmt :red, :bold, :on_white

Incorrect use of Col results in a `Col::Error` being raised:

    Col("string").turquoise                    # non-existent format
    Col("one", "two).fmt :red, :green, :cyan   # too many arguments
    Col("string").gZow                         # invalid style: Z

### Abbreviations

Here are some illustrative examples of abbreviations you can use with `col`.

          Code             Effect(s) applied
     ---------------      -------------------
     Col["..."].g         green
     Col["..."].gb        green bold
     Col["..."]._b        bold
     Col["..."].gbow      green bold on_white
     Col["..."].g_ow      green on_white
     Col["..."].__ow      on_white
   
These examples show that the abbreviations are positional.  If you only want to
specify `on_white`, you must use underscores for the color and style properties.

Using these abbreviations, you can apply at most one color, at most one style,
and at most one background color.  These are listed in full here:

    COLORS = {              STYLES = {                    BACKGROUND = {        
      'B' => :black,          'b' => :bold,                 'oB' => :on_black,  
      'r' => :red,            'd' => :dark,                 'or' => :on_red,    
      'g' => :green,          'i' => :italic,               'og' => :on_green,  
      'y' => :yellow,         'u' => :underline,            'oy' => :on_yellow, 
      'b' => :blue,           'U' => :underscore,           'ob' => :on_blue,   
      'm' => :magenta,        'k' => :blink,                'om' => :on_magenta,
      'c' => :cyan,           'r' => :rapid_blink,          'oc' => :on_cyan,   
      'w' => :white           'n' => :negative,             'ow' => :on_white   
    }                         'c' => :concealed,          }                     
                              's' => :strikethrough,
                            }                       
    
Note the following solutions to abbreviation clashes:

* `b` for blue, `B` for black
* `u` for underline, `U` for underscore
* `b` for bold; `k` for blink.

### Unabbreviated usage

Col is designed to make colorising a string (or collection of strings) easy, and
is optimised for the common case of applying a single color, a single style and
a background color.  If you need to apply more than one style to a single
string, you can send them all as methods:

    Col("text...").rapid_blink.strikethrough.negative.cyan

Or you can pass all of them, in full, to the `fmt` method.

    Col("text...").fmt [:rapid_blink, :strikethrough, :negative, :cyan]

If you are using `Col` to format a number of strings, `fmt` is your only option.

    Col("one", "two", "three").fmt(
      [:green, :bold, :underline, :italic, :on_yellow],
      [:blue, :strikethrough, :dark, :blink],
      [:red]
    )

Naturally, the need for such usage should be extremely rare!

### Formatting multiple strings

Assuming your formatting needs are straightforward, the most convenient way to
format multiple strings is with a comma-separated format specification.

    puts Col(str1, str2, ...).fmt "f1,f2,..."

For example

    puts Col("Name: ", name, "Age: ", age).fmt "y,rb,y,rb"

    # Equivalent to:
    puts Col("Name: ",  name,           "Age: ",   age           ).fmt \
             :yellow,   [:red, :bold],  :yellow,   [:red, :bold]

An alternative is to provide a list of strings or symbols:

    puts Col("Name: ", name, "Age: ", age).fmt('y', 'rb', 'y', 'rb')
    puts Col("Name: ", name, "Age: ", age).fmt(:y, :rb, :y, :rb)


## Limitations

Col uses [`term/ansicolor`][1] to access ANSI codes, and offers access to all of
its codes/features _except_ `reset` and `uncolored`.  There is no way to uncolor
a string using Col; there should be no need to!  Nonetheless, by using Col you
are indirectly using `term/ansicolor` and can therefore include code like

    str = Term::ANSIColor.uncolored(str)

[1]: http://flori.github.com/term-ansicolor/

The author of this library never applies anything other than a foreground color
and 'bold', so everything else is tested only in unit tests, not in practice.
Furthermore, the author has no knowledge of terminal issues and is just happy to
see a few colors appear in his Ruby 1.8 (Cygwin) programs -- no other
environment has been tested!


## Endnotes

### Credits

Florian Flank for [`term/ansicolor`][1], which I've used heavily over the years.

### Motivation

I've used `term/ansicolor` many times and never sought anything more, but while
developing Attest, which makes much use of console color, I wanted an easier way
to apply color codes to groups of strings.  Additionally, being a unit testing
library, I didn't want to add methods to the String class, the way I normally do
when using `term/ansicolor`.

### Project details

* Author: Gavin Sinclair (user name: gsinclair; mail server: gmail.com)
* Date: July 2010
* Licence: MIT licence
* Project page: [http://github.com/gsinclair/col][pr]
* Documentation:
  * [http://gsinclair.github.com/col.html][d1] or
  * [http://github.com/gsinclair/col#README][d2]

[pr]: http://github.com/gsinclair/col
[d1]: http://gsinclair.github.com/col.html
[d2]: http://github.com/gsinclair/col#README

### Future plans

Hopefully nothing in the code will need to change.  Bug fixes will be released
as version 1.0.1, 1.0.2 etc.  If any requests are made for enhanced
functionality, they will be 1.1.0, 1.2.0 etc.
