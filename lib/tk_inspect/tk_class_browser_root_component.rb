module TkInspect
  class TkClassBrowserRootComponent < TkComponent::Base
    attr_accessor :class_browser

    def generate(parent_component, options = {})
      parse_component(parent_component, options) do |p|
        p.hframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
          ([ nil ] + class_browser.selected_class_path).each.with_index do |c, idx|
            next_in_path = class_browser.selected_class_path[idx]
            f.tree(sticky: 'nsew', h_weight: 1, v_weight: 1) do |t|
              class_browser.subclasses_of(c).sort.each do |klass|
                t.tree_node(at: 'end', text: klass.to_s, selected: klass.to_s == next_in_path)
              end
              t.on_select ->(e) { select_class(e.sender, idx) }
            end
          end
        end
      end
    end

    def select_class(sender, index)
      class_name = sender.native_item.selection&.first.text
      return unless class_name.present? && !class_browser.selected_class_path.include?(class_name)
      class_browser.select_class_at_index(class_name, index)
      regenerate
    end
  end
end
