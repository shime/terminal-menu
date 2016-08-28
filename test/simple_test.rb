require File.dirname(__FILE__) + '/test_helper'

describe TerminalMenu do
  it "should select first option after pressing enter" do
    @input = "\r" # press enter
    @output = ''
    @menu = TerminalMenu.new(stdin: StringIO.new(@input),
                             stdout: StringIO.new(@output)) do |selected|
      selected.must_equal '1'
      @menu.quit
    end
    @menu.add('1')
    @menu.add('2')
    @menu.add('3')
    @menu.show
  end

  it "should select second option after going down and pressing enter" do
    @input = "j\r" # go down and press enter
    @output = ''
    @menu = TerminalMenu.new(stdin: StringIO.new(@input),
                             stdout: StringIO.new(@output)) do |selected|
      selected.must_equal '2'
      @menu.quit
    end
    @menu.add('1')
    @menu.add('2')
    @menu.add('3')
    @menu.show
  end

  it "should select third option after going up twice and pressing enter" do
    @input = "kk\r" # go up twice and press enter
    @output = ''
    @menu = TerminalMenu.new(stdin: StringIO.new(@input),
                             stdout: StringIO.new(@output)) do |selected|
      selected.must_equal '3'
      @menu.quit
    end
    @menu.add('1')
    @menu.add('2')
    @menu.add('3')
    @menu.show
  end

  it "should never get to the selected callback when selecting exit" do
    @input = "k\r" # go up and press enter
    @output = ''
    @menu = TerminalMenu.new(stdin: StringIO.new(@input),
                             stdout: StringIO.new(@output)) do |selected|
      raise Exception
    end
    @menu.add('1')
    @menu.add('2')
    @menu.add('3')
    @menu.show
  end

  it "should never get to the selected callback when quitting with 'q'" do
    @input = "q" # press q
    @output = ''
    @menu = TerminalMenu.new(stdin: StringIO.new(@input),
                             stdout: StringIO.new(@output)) do |selected|
      raise Exception
    end
    @menu.add('1')
    @menu.add('2')
    @menu.add('3')
    @menu.show
  end
end

