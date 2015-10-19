require "./vgcr"
require "spec"

assert { Valgrind.running_on_valgrind.should eq(1) }
