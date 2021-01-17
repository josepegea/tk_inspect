module TkInspect
  module Inspector
    class RootComponent < TkComponent::Base
      attr_accessor :inspector

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
            f.insert_component(TkComponent::TableViewComponent, self,
                               data_source: self,
                               columns: [
                                 { key: :var, text: 'Variable', anchor: 'w' },
                                 { key: :klass, text: 'Class', anchor: 'w' },
                                 { key: :value, text: 'Value', anchor: 'e' }
                               ],
                               nested: true,
                               lazy: true,
                               sticky: 'nsew', h_weight: 1, v_weight: 1)
          end
        end
      end

      def items_for_path(path = nil)
        path = [] if path.blank?
        if path.empty?
          vars = inspector.inspected_binding.local_variables.sort.map do |var_name|
            value = inspector.inspected_binding.local_variable_get(var_name)
            { var: var_name, klass: value.class.to_s, value: value }
          end
          self_value = eval('self', inspector.inspected_binding)
          [ { var: 'self', klass: self_value.class.to_s, value: self_value }, *vars ]
        else
          obj = path.last[:value]
          obj.children_for_tk_inspect.map do |child_name, child_value|
            { var: child_name, klass: child_value.class.to_s, value: child_value }
          end
        end
      end

      def has_sub_items?(path)
        path = [] if path.blank?
        if path.empty?
          return true # At least we have self
        else
          obj = path.last[:value]
          obj.children_for_tk_inspect.any?
        end
      end
    end
  end
end
