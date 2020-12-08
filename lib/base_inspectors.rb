class Object
  def id_for_tk_inspect
    object_id.to_s
  end

  def value_for_tk_inspect
    to_s
  end

  def number_of_children_for_tk_inspect
    0
  end

  def children_for_tk_inspect
    {}
  end
end

class Array
  def value_for_tk_inspect
    "#{size} elements"
  end

  def number_of_children_for_tk_inspect
    size
  end

  def children_for_tk_inspect
    map.with_index { |obj, idx| [ idx.to_s, obj ] }.to_a
  end
end

class Hash
  def value_for_tk_inspect
    "#{size} elements"
  end

  def number_of_children_for_tk_inspect
    size
  end

  def children_for_tk_inspect
    self
  end
end
