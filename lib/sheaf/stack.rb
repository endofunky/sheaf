module Sheaf
  class Stack
    include Enumerable

    class RootClass < Stack
      def add(*args, &block)
        Stack.new(*args, &block)
      end

      def call(*args)
        yield(*args) if block_given?
      end

      def ==(other)
        object_id == other.object_id
      end

      def each; end
    end

    Root = RootClass.new

    SWYM = proc {}

    protected

    attr_reader :stackable, :parent

    public

    class << self
      def new(*args, &block)
        args.empty? ? Root : super
      end

      def [](*args)
        return new if args.empty?

        args[1..-1].inject(new(args[0])) do |stack, stackable|
          stack.add(stackable)
        end
      end

      def build(&block)
        DSLProxy.apply(new, &block)
      end
    end

    def initialize(stackable = Root, parent = Root)
      @stackable = stackable
      @parent = parent
    end

    def call(*args, &block)
      parent.(*args) do |*args|
        stackable.(*args, &block || SWYM)
      end
    end

    def each(&block)
      parent.each(&block)
      stackable.kind_of?(self.class) ? stackable.each(&block) : yield(stackable)
    end

    def fmap(&block)
      self.class[*map(&block)]
    end

    def to_a
      map { |stackable| stackable }
    end

    def to_s
      "#<#{self.class.name}: #{to_a}>"
    end

    alias inspect to_s

    def add(stackable)
      self.class.new(stackable, self)
    end

    def ==(other)
      stackable == other.stackable && parent == other.parent
    end
  end
end

