module Sheaf
  class DSLProxy < SimpleDelegator
    def self.apply(receiver, &block)
      new(receiver).apply(&block)
    end

    def apply(&block)
      instance_eval(&block)
    end

    def method_missing(meth, *args, &block)
      __setobj__ super(meth, *args, &block)
    end
  end
end

