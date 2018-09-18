# Unit testing an AWS CLI script in shUnit2/Placebo

[![Build Status](https://img.shields.io/travis/alexharv074/shunit2_example.svg)](https://travis-ci.org/alexharv074/shunit2_example)

This is code that goes with my blog posts [here](https://alexharv074.github.io/2018/09/07/testing-aws-cli-scripts-in-shunit2.html) and [here](https://alexharv074.github.io/2018/09/18/using-bash-placebo-to-auto-generate-mocks-in-unit-tests.html).

# Usage

Clone this repo:

~~~ text
$ git clone https://github.com/alexharv074/shunit2_example.git
~~~

Install patched shunit2 & Placebo:

~~~ text
$ curl -o /usr/local/bin/shunit2 \
    https://raw.githubusercontent.com/kward/shunit2/07bb3292048a4982aad7247bdd7890f2bf532ece/shunit2
$ curl -o /usr/local/bin/placebo \
    https://raw.githubusercontent.com/alexharv074/bash_placebo/master/placebo
~~~

Run the tests:

~~~ text
$ cd shunit2_example/
$ bash shunit2/delete_stack.sh
~~~
