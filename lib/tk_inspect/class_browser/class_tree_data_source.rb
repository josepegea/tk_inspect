module TkInspect
  module ClassBrowser
    class ClassTreeDataSource
      attr_accessor :class_filter

      def items_for_path(path)
        path = [] if path.blank?
        parent_class = path.last
        subclasses_of(parent_class).sort
      end

      def title_for_path(path, items)
        "#{items.count} #{'class'.pluralize(items.count)}"
      end

      private

      def subclasses_of(class_name)
        filtered_classes.select do |k|
          k.superclass&.to_s == class_name
        end.map { |k| name_for_class(k) }
      end

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
    end
  end
end

