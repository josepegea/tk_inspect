module TkInspect
  module Console
    class RootComponent < TkComponent::Base
      attr_accessor :console

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(sticky: 'nsew', h_weight: 1, v_weight: 1) do |r|
            r.hframe(sticky: 'new', h_weight: 0) do |hf|
              hf.label(text: "Write Ruby code here", sticky: 'w')
              hf.hframe(sticky: 'ne', h_weight: 1) do |buttons|
                buttons.button(text: "Run selected", on_click: :run_selected)
                buttons.button(text: "Return", on_click: :return_from_modal) if console.modal
              end
            end
            r.vpaned(sticky: 'nswe', h_weight: 1, v_weight: 1) do |vp|
              @input = vp.text(sticky: 'nswe', scrollers: 'y', h_weight: 1)
              vp.vframe(padding: "0 0 0 0", sticky: 'nswe', h_weight: 1, v_weight: 1) do |vf|
                vf.label(text: "Output", sticky: 'w')
                @output = vf.text(sticky: 'nswe', scrollers: 'y', h_weight: 1, v_weight: 1)
              end
            end
          end
        end
      end

      def focus_on_code
        @input.tk_item.focus
      end

      def run_modal_loop
        @running_modal_loop = true
        while @running_modal_loop
          Tk.update
          sleep(0.019)
        end
      end

      def run_selected(e)
        code = @input.tk_item.selected_text
        code = @input.tk_item.current_line if code.blank?
        return unless code.present?

        res = console.execute(code)
        @output.tk_item.append_text("\n" + res.to_s);
      end

      def inspect(e)
        console.show_inspector
      end

      def open_class_browser(e)
        console.open_class_browser
      end

      def return_from_modal(e)
        @running_modal_loop = false
      end
    end
  end
end
