module TkInspect
  module ClassBrowser
    class Base
      attr_accessor :tk_root
      attr_accessor :main_component
      attr_accessor :selected_class_path
      attr_accessor :selected_module
      attr_accessor :selected_method
      attr_accessor :browsing_method
      attr_accessor :class_data_sources
      attr_accessor :module_method_data_source

      def initialize
        @tk_root = nil
        @main_component = nil
        @selected_class_path = []
        @loaded_code = {}
        @class_filter = nil
        @browsing_method = 'hierarchy'
        @class_data_sources = {
          hierarchy: ClassTreeDataSource.new,
          namespaces: ClassNamespaceDataSource.new
        }.with_indifferent_access
        @module_method_data_source = ModuleMethodDataSource.new
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

      def class_data_source
        @class_data_sources[browsing_method]
      end

      def select_class_name(class_name)
        self.browsing_method = 'hierarchy'
        class_path = class_data_source.path_for_class(class_name)
        select_class_path(class_path)
      end

      def select_class_path(class_path)
        self.selected_class_path = class_path
        module_method_data_source.selected_class = selected_class_name
      end

      def selected_class_name
        browsing_method.to_s == 'hierarchy' ? self.selected_class_path.last : self.selected_class_path.join('::')
      end

      def code_for_method(meth)
        return nil unless meth.present?
        class_name = selected_class_name
        return nil unless class_name.present?
        klass = Object.const_get(class_name)
        method = klass.instance_method(meth)
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
    end
  end
end
