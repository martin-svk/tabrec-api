## Introduction
This repository contains [Sinatra](http://www.sinatrarb.com) based API for [Tabrec](https://github.com/martin-svk/tabrec),
Google Chrome extension. It was developed as a part of my master thesis assignment at Faculty of Informatics
and Information Technology in Bratislava, Slovakia.

## Setup guide

Requirements:

* Ruby 2.2.1
* Bundler
* PostgreSQL

Setup:

```Bash
# Get source code
git clone git@github.com:martin-svk/tabrec-api.git

# Install gems
bundle install

# Setup databse
rake db:setup

# Run server
bundle exec rackup
```

## License
THE MIT LICENSE (MIT) Copyright © 2015 Martin Toma, martin.toma.svk@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
