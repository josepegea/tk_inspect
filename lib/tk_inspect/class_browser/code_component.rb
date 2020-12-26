require 'active_support/all'

module TkInspect
  module ClassBrowser
    class CodeComponent < TkComponent::Base
      attr_accessor :code
      attr_accessor :filename
      attr_accessor :method_name
      attr_accessor :method_line

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          p.vframe(padding: "0 0 0 0", sticky: 'nsew', h_weight: 1, v_weight: 1) do |vf|
            @filename_label = vf.label(font: 'TkSmallCaptionFont', sticky: 'ewns', h_weight: 1, v_weight: 0)
            @code_text = vf.text(sticky: 'nswe', h_weight: 1, v_weight: 1)
          end
        end
      end

      def update
        if @code && @method_line
          @code_text.tk_item.value = @code
          @code_text.tk_item.select_range("#{@method_line}.0", "#{@method_line}.end")
          @code_text.native_item.see("#{@method_line}.0")
          @filename_label.native_item.text(@filename)
        else
          @code_text.tk_item.value = "Source code not available for #{@method_name}"
        end
      end
    end
  end
end
