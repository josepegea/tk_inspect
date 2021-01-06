require 'active_support/all'

module TkInspect
  module ClassBrowser
    class RootComponent < TkComponent::Base
      attr_accessor :class_browser

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |vf|
            vf.hframe(padding: "0 0 0 0", sticky: 'nse', h_weight: 1, v_weight: 0) do |f|
              f.label(text: "Filter")
              f.entry(value: class_browser.class_data_source.class_filter, on_change: :filter_changed)
            end
            vf.vpaned(sticky: 'nsew', h_weight: 1, v_weight: 1) do |vp|
              @class_browser_comp = vp.insert_component(TkComponent::RBrowserComponent, self,
                                                        data_source: class_browser.class_data_source,
                                                        paned: false,
                                                        sticky: 'nsew', h_weight: 1, v_weight: 1) do |bc|
                bc.on_event'PathChanged', ->(e) { class_selected(e) }
              end
              @module_method_browser_component = vp.insert_component(TkComponent::RBrowserComponent, self,
                                                                     data_source: class_browser.module_method_data_source,
                                                                     paned: false,
                                                                     max_columns: 2,
                                                                     sticky: 'nsew', h_weight: 1, v_weight: 1) do |bc|
                bc.on_event'PathChanged', ->(e) { module_method_selected(e) }
              end
              @code = vp.insert_component(CodeComponent, self, sticky: 'nsew', h_weight: 1, v_weight: 1)
            end
          end
        end
      end

      def class_selected(e)
        @class_browser.select_class_path(e.data_object.selected_path)
        @module_method_browser_component.selected_path = []
        @module_method_browser_component.regenerate
      end

      def module_method_selected(e)
        path = e.data_object.selected_path || []
        module_name = path[0]
        method_name = path[1]
        code, line, file = @class_browser.code_for_method(method_name)
        @code.method_name = method_name
        @code.code = code
        @code.method_line = line
        @code.filename = file
        @code.update
      end

      def filter_changed(e)
        return if class_browser.class_data_source.class_filter == e.sender.s_value
        class_browser.class_data_source.class_filter = e.sender.s_value
        @class_browser.select_class_path([])
        @class_browser_comp.selected_path = []
        @module_method_browser_component.selected_path = []
        @class_browser_comp.regenerate
        @module_method_browser_component.regenerate
      end
    end
  end
end
