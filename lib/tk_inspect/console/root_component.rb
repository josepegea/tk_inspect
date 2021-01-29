module TkInspect
  module Console
    class RootComponent < TkComponent::Base
      attr_accessor :console

      def render(p, parent_component)
        p.vframe(sticky: 'nsew', x_flex: 1, y_flex: 1) do |r|
          r.hframe(sticky: 'new', padding: '8', x_flex: 0) do |hf|
            hf.label(text: "Write Ruby code here", sticky: 'w')
            hf.hframe(sticky: 'ne', x_flex: 1) do |buttons|
              buttons.button(text: "Run selected", default: "active", on_click: :run_selected)
              buttons.button(text: "Return", on_click: :return_from_modal) if console.modal
            end
          end
          r.vpaned(sticky: 'nswe', x_flex: 1, y_flex: 1) do |vp|
            @input = vp.text(sticky: 'nswe', scrollers: 'y',
                             highlightthickness: 0,
                             x_flex: 1, y_flex: 1)
            vp.vframe(padding: "0 0 0 0", sticky: 'nswe', x_flex: 1, y_flex: 1) do |vf|
              vf.hframe(sticky: 'new', padding: '8', x_flex: 0) do |hf|
                hf.label(text: "Output", padding: '8', sticky: 'w')
                hf.hframe(sticky: 'ne', x_flex: 1) do |buttons|
                  buttons.button(text: "Clear", on_click: :clear_output)
                end
              end
              @output = vf.text(sticky: 'nswe', scrollers: 'y',
                                background: 'systemSheetBackgroundOpaque', highlightthickness: 0,
                                x_flex: 1, y_flex: 1)
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
        show_output(res)
      end

      def inspect_selected(e)
        code = @input.tk_item.selected_text
        code = @input.tk_item.current_line if code.blank?
        return unless code.present?

        res = console.open_inspector(code)
      end

      def show_output(res)
        @output.tk_item.append_text(res.to_s + "\n");
      end

      def zoom_in(e)
        zoom_by(1.1, @input)
        zoom_by(1.1, @output)
      end

      def zoom_out(e)
        zoom_by(0.9091, @input)
        zoom_by(0.9091, @output)
      end

      def zoom_by(factor, item)
        font = item.native_item.font
        new_font = TkFont.new(family: font.family, weight: font.weight, size: (font.size * factor).ceil)
        geom = console.tk_root.tk_item.native_item['geometry']
        item.native_item.font(new_font)
        console.tk_root.tk_item.native_item['geometry'] = geom
      end

      def clear_output(e)
        @output.tk_item.value = ''
      end

      def inspect(e)
        console.open_inspector
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
