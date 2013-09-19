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

Object以下のクラス関係を表示

tree = ObjectTree::Tree.create(Object)
tree.draw

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
