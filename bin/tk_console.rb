#!/usr/bin/env ruby

require "bundler/setup"
require "tk_inspect"
require "pry"

console = TkInspect::TkConsole.new
console.refresh

Tk.mainloop

