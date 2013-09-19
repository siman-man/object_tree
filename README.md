# ObjectTree

Rubyのオブジェクト関係をtreeっぽく表示

## Installation

Add this line to your application's Gemfile:

    gem 'object_tree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_tree

## Usage

require 'object_tree'

class A
end

class B < A
end

class C < A
end

tree = ObjectTree::Tree.create(A)
tree.draw


実行すると

<C>A
├─ ─ ── <C>C
└─ ─ ── <C>B

こんな感じでtreeっぽく継承関係を出力してくれる。

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
