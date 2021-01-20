module TkInspect
  module Inspector
    class RootComponent < TkComponent::Base
      attr_accessor :inspector

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
            @table = f.insert_component(TkComponent::TableViewComponent, self,
                                        data_source: self,
                                        columns: [
                                          { key: :var, text: 'Variable', anchor: 'w' },
                                          { key: :value, text: 'Value', anchor: 'center' },
                                          { key: :klass, text: 'Class', anchor: 'center' }
                                        ],
                                        nested: true,
                                        lazy: true,
                                        sticky: 'nsew', h_weight: 1, v_weight: 1)
            f.hframe(sticky: 'se', padding: '8', h_weight: 1) do |hf|
              hf.button(text: "Browse selected class", on_click: :browse_class)
              hf.button(text: "Refresh", on_click: ->(e) { regenerate })
            end
          end
        end
      end

      def items_for_path(path = nil)
        path = [] if path.blank?
        if path.empty?
          self_exp = inspector.expression || 'self'
          self_value = eval(self_exp, inspector.inspected_binding)
          res = [{ var: self_exp, value: self_value.value_for_tk_inspect, klass: self_value.class.to_s, real_value: self_value }]
          if inspector.expression.blank?
            vars = inspector.inspected_binding.local_variables.sort.map do |var_name|
              value = inspector.inspected_binding.local_variable_get(var_name)
              res << { var: var_name, value: value.value_for_tk_inspect, klass: value.class.to_s, real_value: value }
            end
          end
          res
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

      def browse_class(e)
        item = @table.selected_item
        return unless item && (class_name = item[:klass])
        class_browser = TkInspect::ClassBrowser::Controller.new
        class_browser.select_class_name(class_name)
        class_browser.refresh
      end
    end
  end
end
