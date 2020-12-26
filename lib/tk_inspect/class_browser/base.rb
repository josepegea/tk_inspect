module TkInspect
  module ClassBrowser
    class Base
      attr_accessor :tk_root
      attr_accessor :main_component
      attr_accessor :selected_class_path
      attr_accessor :selected_module
      attr_accessor :selected_method
      attr_accessor :class_filter

      def initialize
        @tk_root = nil
        @main_component = nil
        @selected_class_path = []
        @loaded_code = {}
        @class_filter = nil
      end

      def refresh
        @main_component.nil? ? create_root : @main_component.regenerate
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: "Class Browser")
        @main_component = RootComponent.new
        @main_component.class_browser = self
        @tk_root.place_root_component(@main_component)
      end

      def subclasses_of(class_name)
        filtered_classes.select do |k|
          k.superclass&.to_s == class_name
        end.map { |k| name_for_class(k) }
      end

      def select_class(class_name)
        klass = Object.const_get(class_name)
        return if klass.blank?
        @selected_class_path = [class_name]
        while (klass = klass.superclass).present? do
          @selected_class_path.unshift(klass.name)
        end
        select_module(class_name)
      end

      def modules_of(class_name)
        return [] unless class_name.present?
        klass = Object.const_get(class_name)
        # We start with the empty module (to show all methods) and the class itself
        modules = [ nil, klass ]
        # Now we add the ancestor classes
        parent = klass.superclass
        while parent do
          modules << parent
          parent = parent.superclass
        end
        # Last, we add the included modules
        (modules + klass.singleton_class.included_modules).map { |m| name_for_module(m) }
      end

      def select_module(module_name)
        self.selected_module = module_name
        select_method(nil)
      end

      def methods_of(mod)
        methods = nil
        if mod.nil?
          # We want all the methods of the selected class
          mod = Object.const_get(selected_class_path.last)
          methods = mod&.instance_methods(true)
        else
          mod = Object.const_get(mod)
          methods = mod&.instance_methods(false)
        end
        methods.map { |m| name_for_method(m) }
      end

      def select_method(method_name)
        self.selected_method = method_name
      end

      def code_for_selected_method
        return nil unless self.selected_method.present?
        class_name = selected_class_path.last
        return nil unless class_name.present?
        klass = Object.const_get(class_name)
        method = klass.instance_method(self.selected_method)
        file, line = method.source_location
        return nil unless file && line
        return code_for_file(file), line, file
      end

      def code_for_file(file)
        @loaded_code[file] || begin
                                @loaded_code[file] = IO.read(file)
                                @loaded_code[file]
                              end
      end

      private

      def filtered_classes
        list = ObjectSpace.each_object(Class).select do |k|
          !k.name.nil?
        end
        return list if @class_filter.blank?
        list.select! do |k|
          k.name.match(/#{@class_filter}/i)
        end
        ancestors = list.reduce(Set.new) do |acum, k|
          an = k
          while !(an = an.superclass).nil? do
            acum << an
          end
          acum
        end
        (list.to_set + ancestors).to_a
      end

      def name_for_class(klass)
        klass.respond_to?(:name) ? klass.name : klass.to_s
      end

      def name_for_module(mod)
        return mod if mod.nil?
        name_for_class(mod)
      end

      def name_for_method(med)
        med.to_s
      end
    end
  end
end
