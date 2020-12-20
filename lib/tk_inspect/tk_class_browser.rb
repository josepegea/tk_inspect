module TkInspect
  class TkClassBrowser
    attr_accessor :tk_root
    attr_accessor :main_component
    attr_accessor :selected_class_path

    def initialize
      @tk_root = nil
      @main_component = nil
      @selected_class_path = []
    end

    def refresh
      @main_component.nil? ? create_root : @main_component.regenerate
    end

    def create_root
      @tk_root = TkComponent::Window.new(title: "Class Browser")
      @main_component = TkClassBrowserRootComponent.new
      @main_component.class_browser = self
      @tk_root.place_root_component(@main_component)
    end

    def subclasses_of(klass)
      klass = Object.const_get(klass.to_s) if klass.present?
      ObjectSpace.each_object(Class).select { |k| k.superclass == klass }.map(&:to_s)
    end

    def select_class_at_index(class_name, index)
      if index <= selected_class_path.size
        selected_class_path[index] = class_name
        selected_class_path.slice!(index + 1, selected_class_path.size - index)
      end
    end
  end
end
