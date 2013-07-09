MimosaTestem
===============

A sample Mimosa project with tests run via testem using [https://github.com/dbashford/mimosa-testem-require](mimosa-testem-require).

__Zero__ config required.  Just write tests.  Mimosa will figure out what config you need to execute the tests and will run the tests for you automatically when Mimosa starts and with each file save.

## How to Use

* Install the latest Mimosa. `0.13.12` required.
* `npm install -g phantomjs` (necessary for headless test running)
* `git clone https://github.com/dbashford/MimosaTestem`
* `cd MimosaTestem`
* mimosa watch -s

## What will happen?

First Mimosa will install into your project `mimosa-testem-require`, an external Mimosa module that does not come by default with Mimosa (yet).

Then all of the default Mimosa stuff...

* Compiling CoffeeScript, Stylus, Handlebars
* Linting of CSS/JS
* Express server will be started

Then `mimosa-testem-require` kicks in, it...

# writes several files to the `.mimosa` directory of the application.  Those files are necessary for test running and some are dynamic based on what Mimosa has learned about the project while processing its files.
# fires up the [testem](https://github.com/airportyh/testem) test runner
# testem loads the Mimosa generated test suite using PhantomJS
# that test suite, which includes the `repo-view_spec` runs and a message regarding test success prints to the screen.