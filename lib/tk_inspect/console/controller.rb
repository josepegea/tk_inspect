module TkInspect
  module Console
    class Controller
      attr_accessor :tk_root
      attr_accessor :main_component
      attr_accessor :eval_binding

      def initialize
        @tk_root = nil
        @main_component = nil
        @inspector = nil
        @eval_binding = binding
      end

      def refresh
        create_root if @main_component.nil?
        @main_component.regenerate
      end

      def execute(code)
        eval(code, eval_binding)
      end

      def show_inspector
        inspector.refresh
      end

      def open_class_browser
        class_browser.refresh
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: "Console #{self.object_id}")
        @main_component = RootComponent.new
        @main_component.console = self
        @tk_root.place_root_component(@main_component)
      end

      def inspector
        @inspector ||= TkInspect::Inspector::Controller.new(eval_binding)
      end

      def class_browser
        @class_browser ||= TkInspect::ClassBrowser::Controller.new
      end
    end
  end
end
