# Unit testing an AWS CLI script in shUnit2

This is code that goes with my blog post [here](https://alexharv074.github.io/2018/09/07/testing-aws-cli-scripts-in-shunit2.html).

# Usage

Clone this repo:

~~~ text
$ git clone https://github.com/alexharv074/shunit2_example.git
~~~

Install patched shunit2:

~~~ text
$ curl \
    https://raw.githubusercontent.com/kward/shunit2/07bb3292048a4982aad7247bdd7890f2bf532ece/shunit2 \
    -o /usr/local/bin/shunit2
~~~

Run the tests:

~~~ text
$ cd shunit2_example/
$ bash shunit2/delete_stack.sh
~~~
