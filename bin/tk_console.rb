#!/usr/bin/env ruby

require "bundler/setup"
require "tk_inspect"
require "pry"

console = TkInspect::Console::Controller.new
console.refresh

Tk.mainloop

