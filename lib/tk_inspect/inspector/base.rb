module TkInspect
  module Inspector
    class Base
      cattr_accessor :shared_inspector
      cattr_accessor :custom_inspectors

      self.custom_inspectors = {}

      attr_accessor :inspected_binding
      attr_accessor :expression
      attr_accessor :tk_root
      attr_accessor :main_component

      def self.shared_inspector
        shared_inspector ||= self.new
      end

      def self.register_shared_inspector(inspector_class, inspected_class)
        custom_inspectors[inspected_class] = inspector_class
      end

      def self.inspector_for_class(klass)
        while klass && !(inspector = custom_inspectors[klass]) do
          klass = klass.superclass
        end
        inspector || self
      end

      def self.inspector_for_object(obj)
        self.inspector_for_class(obj.class)
      end

      def initialize(options = {})
        @expression = options[:expression]
        @inspected_binding = options[:binding] || binding
        @value = options[:value]
        @tk_root = nil
        @main_component = nil
      end

      def refresh
        @main_component.nil? ? create_root : @main_component.regenerate
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: window_title)
        create_main_component
        @main_component.inspector = self
        @tk_root.place_root_component(@main_component)
      end

      def browse_class(class_name)
        class_browser = TkInspect::ClassBrowser::Base.new
        class_browser.select_class_name(class_name)
        class_browser.refresh
        class_browser.show_current_path
      end

      def create_main_component
        @main_component = RootComponent.new
      end

      def window_title
        "Inspector"
      end
    end
  end
end
