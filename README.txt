= SMS

== DESCRIPTION

SMS is a simple SMS sending application.

== FEATURES

* telephones and contacts book
* Orange Multi Box (Polish) and VoipDiscount gateways support
* contact autocompletion

== TODO

* layout and navigation
* JavaScript improvements
* selection of default gateway
* support for other gateways
* ...

== INSTALL

  git clone git://github.com/qoobaa/sms.git
  cd sms
  git submodule init
  git submodule update
  cp config/database.yml.sample config/database.yml
  cp config/initializers/site_keys.rb.sample config/initializers/site_keys.rb
  rake db:migrate
  ./script/server

== REQUIREMENTS

* Ruby on Rails 2.3 (edge)

== LICENSE

The MIT License

Copyright (c) 2008, Jakub Kuźma

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
