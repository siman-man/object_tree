# ObjectTree

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
