# ObjectTree

Rubyのオブジェクト関係をtreeっぽく表示
1.8の対応はまだ出来ていません。

## Installation

Or install it yourself as:

    $ gem install object_tree
    
Add this line to your application's Gemfile:

    gem 'object_tree'

## Usage

``` ruby
require 'object_tree'

class A
end

class B < A
end

class C < A
end

tree = ObjectTree::Tree.create(A)
tree.draw
```

```zsh
<C>A
├──── <C>C
└──── <C>B
```

こんな感じでtreeっぽく出力してくれる。


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

tree = ObjectTree::Tree.create(A, true)
tree.draw
```

```zsh
<M>D
└────<C>A
        ├──── <M>E
        │       └──── <C>C
        └──── <C>B
```

第二引数をtrueにするとmoduleも表示してくれる。


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
