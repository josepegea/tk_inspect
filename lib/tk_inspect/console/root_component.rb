module TkInspect
  module Console
    class RootComponent < TkComponent::Base
      attr_accessor :console

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(sticky: 'nswe') do |vf|
            @input = vf.text(sticky: 'nswe', value: "Ruby console\nWrite Ruby code here\n> ", h_weight: 1)
            vf.hframe(sticky: 'e', h_weight: 0) do |hf|
              hf.button(text: "Class Browser", on_click: :open_class_browser)
              hf.button(text: "Inspect", on_click: :inspect)
              hf.button(text: "Run selected", on_click: :run_selected)
            end
            @output = vf.text(sticky: 'nswe', value: "Code ouput\n> ", h_weight: 1)
          end
        end
      end

      def run_selected(e)
        code = @input.tk_item.selected_text
        res = console.execute(code)
        @output.tk_item.append_text("\n" + res.to_s);
      end

      def inspect(e)
        console.show_inspector
      end

      def open_class_browser(e)
        console.open_class_browser
      end
    end
  end
end
