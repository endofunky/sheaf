require 'helper'

class TestStack < MiniTest::Test
  include Sheaf

  class A
    def call(output)
      yield(output << self.class)
    end
  end

  class B < A; end
  class C < A; end
  class D < A; end
  class E < A; end

  class End < A
    def call(output)
      :ok
    end
  end

  def test_root_type
    refute_kind_of Class, Stack::Root
    assert_kind_of Stack, Stack::Root
    assert_kind_of Stack::RootClass, Stack::Root
  end

  def test_new_without_parameters
    output = []
    Stack.new.add(A).fmap(&:new).(output)
    assert_equal [A], output
    assert_equal [], Stack[].to_a
  end

  def test_build
    stack = Stack.build do
      add A
      add B
      add C
    end

    assert_equal [A, B, C], stack.to_a
  end

  def test_call
    output = []

    ret = Stack[A, B, C, D, E, End].fmap(&:new).(output)

    assert_equal [A, B, C, D, E], output
    assert_equal :ok, ret
  end

  def test_call_to_root_without_block
    assert_nil Stack[].fmap(&:new).()
  end

  def test_call_with_nested_stack
    output = []

    inner = Stack.new(C).add(D)
    ret = Stack.new(A).add(B).add(inner).add(E).add(End).fmap(&:new).(output)

    assert_equal [A, B, C, D, E], output
    assert_equal :ok, ret
  end

  def test_each
    output = []

    Stack[A, B, C].each do |stackable|
      output << stackable
    end

    assert_equal [A, B, C], output
  end

  def test_each_with_nested_stack
    output = []

    Stack[A, Stack[B], C].each do |stackable|
      output << stackable
    end

    assert_equal [A, B, C], output
  end

  def test_to_a
    assert_equal [A, B], Stack[A, B].to_a
  end

  def test_equals
    assert Stack[A] == Stack[A]
    refute Stack[A] == Stack[B]

    assert Stack[A, B] == Stack[A, B]
    refute Stack[A, B] == Stack[B, A]
    refute Stack[A, B] == Stack[A]
    refute Stack[A] == Stack[A, B]

    assert Stack[A, B, C] == Stack[A, B, C]
    refute Stack[A, B, C] == Stack[A, B]
    refute Stack[A, B] == Stack[A, B, C]
  end

  def test_to_s
    assert_equal "#<Sheaf::Stack: [TestStack::A, TestStack::B, TestStack::C]>",
                 Stack[A, B, C].to_s
  end

  def test_inspect
    assert_equal Stack.instance_method(:inspect),
                 Stack.instance_method(:to_s)
  end
end

