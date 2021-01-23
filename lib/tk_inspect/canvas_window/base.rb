module TkInspect
  module CanvasWindow
    class Base
      attr_accessor :tk_root
      attr_accessor :main_component

      delegate :canvas, to: :main_component

      def initialize
        @tk_root = nil
        @main_component = nil
      end

      def refresh
        @main_component.nil? ? create_root : @main_component.regenerate
        self
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: "Canvas Window")
        @main_component = RootComponent.new
        @main_component.canvas_window = self
        @tk_root.place_root_component(@main_component)
      end
    end
  end

  module Console
    class Base
      def new_canvas_window
        TkInspect::CanvasWindow::Base.new.refresh
      end
    end
  end
end
