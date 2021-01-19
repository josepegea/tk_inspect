module TkInspect
  module Inspector
    class Controller
      cattr_accessor :shared_inspector

      attr_accessor :inspected_binding
      attr_accessor :expression
      attr_accessor :tk_root
      attr_accessor :main_component

      def self.shared_inspector
        shared_inspector ||= self.new
      end

      def initialize(expression = nil, inspected_binding = binding)
        @expression = expression
        @inspected_binding = inspected_binding
        @tk_root = nil
        @main_component = nil
      end

      def refresh
        @main_component.nil? ? create_root : @main_component.regenerate
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: "Inspector")
        @main_component = RootComponent.new
        @main_component.inspector = self
        @tk_root.place_root_component(@main_component)
      end
    end
  end
end
