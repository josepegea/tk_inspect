#!/usr/bin/env ruby

require "bundler/setup"
require "tk_inspect"
require "pry"

console = TkInspect::Console::Controller.new(root: true)
console.focus

Tk.mainloop

