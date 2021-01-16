module TkInspect
  module ClassBrowser
    class ModuleMethodDataSource
      attr_accessor :selected_class

      def items_for_path(path)
        path = [] if path.blank?
        case path.size
        when 0
          return modules_of(selected_class)
        when 1
          return methods_of(path.first)
        else
          return []
        end
      end

      def title_for_path(path, items)
        path = [] if path.blank?
        case path.size
        when 0
          return "#{selected_class} -> #{items.size} #{'module'.pluralize(items.size)}"
        when 1
          if (module_name = path.first).present?
            return "#{module_name} -> #{items.size} #{'method'.pluralize(items.size)}"
          else
            "#{items.size} #{'method'.pluralize(items.size)} in total"
          end
        else
          return ''
        end
      end

      private

      def modules_of(class_name)
        return [] unless class_name.present?
        begin
          klass = Object.const_get(class_name)
        rescue NameError
          return []
        end
        return [] unless klass.is_a?(Class)
        # We start with the empty module (to show all methods) and the class itself
        modules = [ label_for_all_modules, klass ]
        # Now we add the ancestor classes
        parent = klass.superclass
        while parent do
          modules << parent
          parent = parent.superclass
        end
        # Last, we add the included modules
        (modules + klass.singleton_class.included_modules).map { |m| name_for_module(m) }
      end

      def methods_of(mod)
        methods = nil
        if mod == label_for_all_modules
          # We want all the methods of the selected class
          mod = Object.const_get(selected_class)
          methods = mod&.instance_methods(true)
        else
          mod = Object.const_get(mod)
          methods = mod&.instance_methods(false)
        end
        methods
          .map { |m| name_for_method(m) }
          .sort
      end

      def name_for_module(mod)
        return mod if mod.nil?
        mod.respond_to?(:name) ? mod.name : mod.to_s
      end

      def name_for_method(meth)
        meth.to_s
      end

      def label_for_all_modules
        '<all>'
      end
    end
  end
end

