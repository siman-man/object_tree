# ObjectTree

[![Build Status](https://travis-ci.org/siman-man/object_tree.svg?branch=master)](https://travis-ci.org/siman-man/object_tree)

ObjectTree is like tree command for Ruby ancestors.


## Installation

```
$ gem install object_tree
```

    
## Usage

``` ruby
require 'object_tree'

class A
end

class B < A
end

class C < B
end

puts ObjectTree.create(A)
```

output

```zsh
<C> A
└───── <C> B
        └───── <C> C
```


more complex pattern

```ruby
require 'object_tree'

module D
end

module E
end

class A
  include D
end

class B < A
end

class C < A
  include E
end

class F < B
  include E
end

puts ObjectTree.create(D)
```

output

```
<M> D
└───── <C> A
        ├───── <C> B
        │       └───── <M> E
        │               └───── <C> F
        └───── <M> E
                └───── <C> C
```

can use from terminal by using `rotree` command.

```
$ rotree Numeric                                                                                                                                       [master]
```

Ruby 2.3.3

```
<C> Numeric
├───── <C> Complex
├───── <C> Float
├───── <C> Integer
│       ├───── <C> Bignum
│       └───── <C> Fixnum
└───── <C> Rational
```

Ruby 2.4.0

```
<C> Numeric
├───── <C> Complex
├───── <C> Float
├───── <C> Integer
└───── <C> Rational
```

you can see unify Fixnum and Bignum into Integer from ruby 2.4.0

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
