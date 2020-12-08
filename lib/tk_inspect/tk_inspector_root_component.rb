module TkInspect
  class TkInspectorRootComponent < TkComponent::Base
    attr_accessor :inspector

    def generate(parent_component, options = {})
      parse_component(parent_component, options) do |p|
        p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
          f.tree(columns: 'klass value') do |t|
            inspector.inspected_binding.local_variables.each do |var_name|
              add_obj(t, var_name, inspector.inspected_binding.local_variable_get(var_name))
            end
          end
        end
      end
    end

    def add_obj(t, name, obj, parent = nil)
      item = t.tree_node(parent: parent || '', at: 'end', text: name, values: [obj.class.to_s, obj.value_for_tk_inspect])
      obj.children_for_tk_inspect.each do |child_name, child_obj|
        add_obj(t, child_name, child_obj, item)
      end
    end
  end
end
