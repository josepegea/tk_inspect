module TkInspect
  module CanvasWindow
    class RootComponent < TkComponent::Base
      attr_accessor :canvas_window

      def render(p, parent_component)
        @canvas = p.canvas(sticky: 'nwes', x_flex: 1, y_flex: 1)
      end

      def canvas
        @canvas.native_item
      end
    end
  end
end
