module Case1
  class A
  end

  class B < A
  end

  class C < B
  end
end

module Case2
  module A
  end

  class B
    include A
  end
end

module Case3
  class A
  end

  class B < A
  end

  class C < A
  end
end

module Case4
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
end

module Case5
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
end
