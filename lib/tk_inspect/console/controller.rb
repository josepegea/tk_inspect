module TkInspect
  module Console
    class Controller
      attr_accessor :tk_root
      attr_accessor :main_component
      attr_accessor :eval_binding
      attr_accessor :modal
      attr_accessor :root

      def initialize(options = {})
        @tk_root = nil
        @main_component = nil
        @eval_binding = binding
        @modal = !!options[:modal]
        @root = !!options[:root]
      end

      def focus
        create_root if @main_component.nil?
        @tk_root.focus
        @tk_root.tk_item.native_item.after(100) { @main_component.focus_on_code }
      end

      def refresh
        @main_component.regenerate
        @main_component.focus
      end

      def modal_loop
        @main_component.run_modal_loop
      end

      def execute(code)
        eval(code, eval_binding)
      end

      def say(s)
        main_component.show_output(s)
        return nil
      end

      def open_inspector(expression = nil)
        if expression.present?
          val = eval(expression, eval_binding)
          TkInspect::Inspector::Controller
            .inspector_for_object(val)
            .new(expression: expression,
                 binding: eval_binding,
                 value: val).refresh
        else
          TkInspect::Inspector::Controller
            .new(expression: expression,
                 binding: eval_binding).refresh
        end
      end

      def open_class_browser
        TkInspect::ClassBrowser::Controller.new.refresh
      end

      def create_root
        @tk_root = TkComponent::Window.new(title: "Ruby Console", root: @root)
        @main_component = RootComponent.new
        @main_component.console = self
        @tk_root.place_root_component(@main_component)
        create_menu
        @tk_root.tk_item.native_item.after(100) { @main_component.focus_on_code }
      end

      def create_menu
        @menubar = TkMenu.new(@tk_root.tk_item.native_item)
        file = TkMenu.new(@menubar)
        edit = TkMenu.new(@menubar)
        edit.add :command, label: "Undo", accelerator: 'Command+z', command: -> { Tk.event_generate(Tk.focus, "<Undo>") }
        edit.add :command, label: "Redo", accelerator: 'Command+Shift+z', command: -> { Tk.event_generate(Tk.focus, "<Redo>") }
        edit.add :separator
        edit.add :command, label: "Cut", accelerator: 'Command+x', command: -> { Tk.event_generate(Tk.focus, "<Cut>") }
        edit.add :command, label: "Copy", accelerator: 'Command+c', command: -> { Tk.event_generate(Tk.focus, "<Copy>") }
        edit.add :command, label: "Paste", accelerator: 'Command+v', command: -> { Tk.event_generate(Tk.focus, "<Paste>") }
        edit.add :command, label: "Clear", accelerator: 'Delete', command: -> { Tk.event_generate(Tk.focus, "<Clear>") }
        view = TkMenu.new(@menubar)
        view.add :command, label: "Bigger font", accelerator: 'Command++', command: -> { main_component.zoom_in(nil) }
        view.add :command, label: "Smaller font", accelerator: 'Command+-', command: -> { main_component.zoom_out(nil) }
        tools = TkMenu.new(@menubar)
        tools.add :command, label: "Run selection", accelerator: 'Command+r', command: -> { main_component.run_selected(nil) }
        tools.add :command, label: "Inspect selection", accelerator: 'Command+i', command: -> { main_component.inspect_selected(nil) }
        tools.add :separator
        tools.add :command, label: "Clear output", accelerator: 'Command+k', command: -> { main_component.clear_output(nil) }
        tools.add :separator
        tools.add :command, label: "Inspector ...", accelerator: 'Command+Shift+i', command: -> { open_inspector }
        tools.add :command, label: "Class Browser ...", accelerator: 'Command+Shift+b', command: -> { open_class_browser }
        @menubar.add :cascade, menu: file, label: 'File'
        @menubar.add :cascade, menu: edit, label: 'Edit'
        @menubar.add :cascade, menu: view, label: 'View'
        @menubar.add :cascade, menu: tools, label: 'Tools'
        @tk_root.tk_item.native_item['menu'] = @menubar
        @tk_root.tk_item.native_item.bind('Command-r', -> { main_component.run_selected(nil) })
        @tk_root.tk_item.native_item.bind('Command-k', -> { main_component.clear_output(nil) })
        @tk_root.tk_item.native_item.bind('Command-+', -> { main_component.zoom_in(nil) })
        @tk_root.tk_item.native_item.bind('Command-minus', -> { main_component.zoom_out(nil) })
        @tk_root.tk_item.native_item.bind('Command-i', -> { main_component.inspect_selected(nil) })
        @tk_root.tk_item.native_item.bind('Command-Shift-i', -> { open_inspector })
        @tk_root.tk_item.native_item.bind('Command-Shift-b', -> { open_class_browser })
      end
    end
  end
end
