module TkInspect
  module Inspector
    class RootComponent < TkComponent::Base
      attr_accessor :inspector

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
            f.tree(sticky: 'nsew', h_weight: 1, v_weight: 1, scrollers: 'y',
                   column_defs: [
                     { key: 'klass', text: 'Class', anchor: 'w' },
                     { key: 'value', text: 'Value', anchor: 'e' }
                   ]) do |t|
              inspector.inspected_binding.local_variables.sort.each do |var_name|
                add_obj(t, var_name, inspector.inspected_binding.local_variable_get(var_name))
              end
            end
          end
        end
      end

      def add_obj(t, name, obj, parent = nil)
        item = t.tree_node(parent: parent || '', at: 'end', text: name, values: [obj.class.to_s, obj.value_for_tk_inspect])
        children = obj.children_for_tk_inspect
        children.sort.each do |child_name, child_value|
          add_obj(t, child_name, child_value, item)
        end
      end
    end
  end
end
