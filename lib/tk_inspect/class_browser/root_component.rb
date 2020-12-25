require 'active_support/all'

module TkInspect
  module ClassBrowser
    class RootComponent < TkComponent::Base
      attr_accessor :class_browser

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |vf|
            vf.hframe(padding: "0 0 0 0", sticky: 'nse', h_weight: 0, v_weight: 1) do |f|
              f.label(text: "Filter")
              f.entry(value: class_browser.class_filter, on_change: :filter_changed)
            end
            vf.hframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
              ([ nil ] + class_browser.selected_class_path).each.with_index do |c, idx|
                next_in_path = class_browser.selected_class_path[idx]
                subclasses = class_browser.subclasses_of(c).sort
                f.tree(sticky: 'nsew', h_weight: 1, v_weight: 1, heading: label_for_class_count(subclasses.size)) do |t|
                  subclasses.each do |class_name|
                    t.tree_node(at: 'end', text: name_for_class(class_name), selected: class_name == next_in_path)
                  end
                  t.on_select ->(e) { select_class(e.sender, idx) }
                end
              end
            end
            vf.hframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
              selected_class = class_browser.selected_class_path.last
              if selected_class
                selected_module = class_browser.selected_module
                modules = class_browser.modules_of(selected_class)
                f.tree(sticky: 'nsew', h_weight: 1, v_weight: 1,
                       heading: label_for_modules(selected_class, modules.size), on_select: :select_module) do |t|
                  modules.each do |mod|
                    t.tree_node(at: 'end', text: name_for_module(mod), selected: mod == selected_module)
                  end
                end
                selected_method = class_browser.selected_method
                methods = class_browser.methods_of(selected_module).sort
                f.tree(sticky: 'nsew', h_weight: 1, v_weight: 1,
                       heading: label_for_methods(selected_module, methods.size), on_select: :select_method) do |t|
                  methods.each do |meth|
                    t.tree_node(at: 'end', text: name_for_method(meth), selected: meth == selected_method)
                  end
                end
              end
            end
            @method_text = vf.text(sticky: 'nswe', h_weight: 1)
          end
        end
      end

      def select_class(sender, index)
        class_name = sender.native_item.selection&.first.text.to_s
        return unless class_name.present?
        puts class_name
        puts class_browser.selected_class_path.join(', ')
        puts index
        return if class_name == class_browser.selected_class_path[index]
        class_browser.select_class(class_name)
        puts "Regenerating..."
        regenerate
      end

      def select_module(e)
        module_name = e.sender.native_item.selection&.first.text
        return unless module_name.present? && name_for_module(class_browser.selected_module) != module_name
        module_name = nil if module_name == '<all>'
        class_browser.select_module(module_name)
        regenerate
      end

      def select_method(e)
        method_name = e.sender.native_item.selection&.first.text
        return unless method_name.present? && name_for_method(class_browser.selected_method) != method_name
        class_browser.select_method(method_name)
        regenerate
        code, line = class_browser.code_for_selected_method
        if code && line
          @method_text.tk_item.value = code
          @method_text.tk_item.select_range("#{line}.0", "#{line}.end")
          @method_text.native_item.see("#{line}.0")
        else
          @method_text.tk_item.value = "Source code not available for #{method_name}"
        end
      end

      def filter_changed(e)
        return if class_browser.class_filter == e.sender.s_value
        class_browser.class_filter = e.sender.s_value
        regenerate
      end

      def name_for_class(class_name)
        class_name
      end

      def name_for_module(mod)
        mod || '<all>'
      end

      def name_for_method(meth)
        meth
      end

      def label_for_class_count(count)
        "#{count} #{'class'.pluralize(count)}"
      end

      def label_for_modules(class_name, count)
        "#{class_name} -> #{count} #{'module'.pluralize(count)}"
      end

      def label_for_methods(module_name, count)
        if module_name.present?
          "#{module_name} -> #{count} #{'method'.pluralize(count)}"
        else
          "#{count} #{'method'.pluralize(count)} in total"
        end
      end
    end
  end
end
