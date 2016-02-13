#!/usr/bin/env ruby

#---------------------------------------------------------------------------------------------------------------------
# Gem dependencies
#---------------------------------------------------------------------------------------------------------------------
require 'readline'
require 'ripl'
require 'ripl/multi_line'
require 'ripl/auto_indent'
require 'ripl/shell_commands'
require 'ripl/color_streams'
require 'ripl/irb'
require 'optparse'
require "method_source"
require 'colored'
require "awesome_print"

#---------------------------------------------------------------------------------------------------------------------
# define the source for commands
#---------------------------------------------------------------------------------------------------------------------
# use lib/commands.rb as the source for the COMMANDS_CLASS constant
COMMANDS_FILE = "../cli_commands.rb"
require_relative COMMANDS_FILE
# Set a variable equaling the class which is loaded from COMMANDS_FILE
COMMANDS_CLASS = Commands

#---------------------------------------------------------------------------------------------------------------------
# the CLI base
#---------------------------------------------------------------------------------------------------------------------
# intance methods in RubyCliSkeleton and COMMANDS_CLASS are available in the cli
class RubyCliSkeleton < COMMANDS_CLASS
  def no_help_methods
    # list of methods which are ignored when the "help" command lists all methods
    [:no_help_methods, :print_and_return]
  end
  def print_and_return(obj)
    # a helper method (used by other commands)
    ap obj
    return obj
  end
  def initialize(options)
    # these options are from OptionParser
    # pass them along to COMMAND_CLASS's initialize
    super(options)
  end
  def ls(dir=".")
    res = `ls`
    puts "#{res} \n#{"just a reminder - this is ruby not shell".yellow}"
    return Dir.glob("#{dir}/*")
  end
  def pwd
    res = `pwd`
    puts "#{res} \n#{"just a reminder - this is ruby not shell".yellow}"
    return res.chomp
    return Dir.glob("./*")
  end
  def help(method_name=nil)
    # If a method_name is given as an argument, show the source for that method
    # Otherwise, list all the methods
    if method_name
      # get the source using the "method_source" gem
      method_source = self.class.instance_method(method_name.to_sym).source rescue nil
      if method_source.nil?
        puts "method not found".red 
      else
        method_source.display
        return method_name.to_sym
      end
    else
      puts "You can see details for a method with 'help(:method_name)'".yellow
      methods = [COMMANDS_CLASS, self.class].map { |klass| klass.instance_methods(false) }.flatten
      print_and_return(methods - no_help_methods)
    end
  end
end

#---------------------------------------------------------------------------------------------------------------------
# Parse command line options
#---------------------------------------------------------------------------------------------------------------------
# none are accepted by default. See http://ruby-doc.org/stdlib-2.3.0/libdoc/optparse/rdoc/OptionParser.html
$options = {}
OptionParser.new do |o|
  o.banner = "Usage: ruby cli.rb (no options accepted)"
  o.parse!
end

#---------------------------------------------------------------------------------------------------------------------
# Start the program
#---------------------------------------------------------------------------------------------------------------------
# start REPL with access to RubyCliSkeleton instance methods
Ripl.start(binding: RubyCliSkeleton.new($options).instance_eval{ binding })