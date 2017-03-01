require 'colorize'

class ObjectTree
  attr_reader :tree

  OPTIONS = { color: true, exclude: [], space_size: 8 }
  SPACE_SIZE = 8
  T_LINE = '├─────'
  I_LINE = '│'
  L_LINE = '└─────'

  def self.create(klass)
    new(klass)
  end

  def initialize(klass)
    @tree = {}
    @queue = []
    parse(klass)
  end

  def to_s
    OPTIONS[:color] ? @queue.join : @queue.join.uncolorize
  end

  def output_node(klass)
    if klass.instance_of?(Class)
      "<#{?C.colorize(:green)}> #{klass}\n"
    else
      "<#{?M.colorize(:red)}> #{klass}\n"
    end
  end

  def get_line(end_line: nil, space: '')
    end_line ? "#{space}#{L_LINE} " : "#{space}#{T_LINE} "
  end

  def get_space(end_line: nil)
    end_line ? ' ' * OPTIONS[:space_size] : I_LINE + ' ' * (OPTIONS[:space_size]-1)
  end

  def parse(klass, space = '', path: [])
    path << klass
    @tree[path.join('/')] = []
    modules = get_modules(klass, path.reverse)
    @queue << output_node(klass)

    while sub = modules.shift
      next if OPTIONS[:exclude].include?(sub.to_s)
      @tree[path.join('/')] << sub
      @queue << get_line(end_line: modules.empty?, space: space)
      parse(sub, space + get_space(end_line: modules.empty?), path: path.dup)
    end
  end

  def get_modules(klass, path)
    ObjectSpace.each_object(Module).map do |k|
      l = k.ancestors
      if l.each_cons(path.size).include?(path)
        (l[l.index(k)..l.index(klass)] - path).last
      end
    end.compact.uniq.sort_by(&:to_s)
  end
end
