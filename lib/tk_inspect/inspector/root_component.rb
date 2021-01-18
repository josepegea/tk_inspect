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
                                 { key: :value, text: 'Value', anchor: 'center' },
                                 { key: :klass, text: 'Class', anchor: 'center' }
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
            { var: var_name, value: value.value_for_tk_inspect, klass: value.class.to_s, real_value: value }
          end
          self_value = eval('self', inspector.inspected_binding)
          [ { var: 'self', value: self_value.value_for_tk_inspect, klass: self_value.class.to_s, real_value: self_value }, *vars ]
        else
          obj = path.last[:real_value]
          obj.children_for_tk_inspect.map do |child_name, child_value|
            { var: child_name, value: child_value.value_for_tk_inspect, klass: child_value.class.to_s, real_value: child_value }
          end
        end
      end

      def has_sub_items?(path)
        path = [] if path.blank?
        if path.empty?
          return true # At least we have self
        else
          obj = path.last[:real_value]
          obj.children_for_tk_inspect.any?
        end
      end
    end
  end
end
