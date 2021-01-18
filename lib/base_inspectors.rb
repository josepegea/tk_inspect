class Object
  def id_for_tk_inspect
    object_id.to_s
  end

  def value_for_tk_inspect
    to_s
  end

  def number_of_children_for_tk_inspect
    instance_variables.size
  end

  def children_for_tk_inspect
    instance_variables.map { |v| [v, instance_variable_get(v)] }.to_h
  end
end

class String
  def value_for_tk_inspect
    frozen? ? dup : self
  end
end

class Array
  def value_for_tk_inspect
    "#{size} elements"
  end

  def number_of_children_for_tk_inspect
    size + super
  end

  def children_for_tk_inspect
    map.with_index { |obj, idx| [ idx.to_s, obj ] }.to_h.merge(super)
  end
end

class Hash
  def value_for_tk_inspect
    "#{size} elements"
  end

  def number_of_children_for_tk_inspect
    size + super
  end

  def children_for_tk_inspect
    merge(super)
  end
end

class Struct
  def value_for_tk_inspect
    "#{size} elements"
  end

  def number_of_children_for_tk_inspect
    size + super
  end

  def children_for_tk_inspect
    to_h.merge(super)
  end
end
