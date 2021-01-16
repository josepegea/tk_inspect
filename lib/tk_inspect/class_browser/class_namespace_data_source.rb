module TkInspect
  module ClassBrowser
    class ClassNamespaceDataSource
      attr_accessor :class_filter

      def items_for_path(path)
        path = [] if path.blank?
        namespace = path.join('::')
        classes = classes_in_namespace(namespace)
        class_names = classes
                        .map { |k| name_for_class(k).gsub(/^#{namespace}(::)?/, '').gsub(/::.*/, '') }
                        .reject { |class_name| class_name.blank? }
                        .uniq
                        .sort
        class_names
      end

      def title_for_path(path, items)
        "#{items.count} #{'class'.pluralize(items.count)}"
      end

      private

      def classes_in_namespace(namespace)
        filtered_classes.select do |k|
          name_for_class(k).match(/^#{namespace}/)
        end
      end

      def filtered_classes
        list = ObjectSpace.each_object(Class).select do |k|
          k.is_a?(Class) && !black_list?(k)
        end
        return list if @class_filter.blank?
        list.select! do |k|
          name_for_class(k).match(/#{@class_filter}/i)
        end
        ancestors = list.reduce(Set.new) do |acum, k|
          acum += name_for_class(k).split('::')
          acum
        end
        (list.to_set + ancestors).to_a
      end

      def name_for_class(klass)
        klass.to_s
      end

      def black_list?(k)
        k.to_s.blank? || k.to_s.match(/^#<Class/) || !k.to_s.match(/^[A-Z]/)
      end
    end
  end
end

