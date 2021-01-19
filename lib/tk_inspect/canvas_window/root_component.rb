module TkInspect
  module CanvasWindow
    class RootComponent < TkComponent::Base
      attr_accessor :controller

      def generate(parent_component, options = {})
        parse_component(parent_component, options) do |p|
          @canvas = p.canvas(sticky: 'nwes', h_weight: 1, v_weight: 1)
        end
      end

      def canvas
        @canvas.native_item
      end
    end
  end
end
