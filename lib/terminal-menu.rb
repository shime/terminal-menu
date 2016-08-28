require 'paint'
require 'io/console'

class TerminalMenu
  # Public: Initializes new TerminalMenu instance.
  #
  # block - Optional block that will get called with label once some option
  #         is selected
  #
  # Options:
  #
  #   title - The title of this menu (default: '')
  #   description - The description of this menu (default: '')
  #   width - The width of this menu in chars (default: 80)
  #   fg - Foreground color of this menu (default: 'white')
  #   bg - Background color of this menu (default: 'black')
  #   stdin - Input IO instance (default: STDIN)
  #   stdout - Output IO instance (default: STDOUT)
  def initialize(title: '', description: '', width: 80,
                 fg: 'white', bg: 'black',
                 stdin: STDIN, stdout: STDOUT, &selected_callback)
    @title = title
    @description = description
    @width = width
    @selected_callback = selected_callback || -> (arg) {}
    @fg = fg
    @bg = bg
    @stdin = stdin
    @stdout = stdout

    @selected_index = 0

    @options = [{label: 'exit', callback:  ->{}}]
    @last_char = []
  end

  # Public: Adds a new item to menu options.
  #
  # label - Label for this menu option.
  # blk - Optional block that will be called once this option is selected.
  def add(label, &blk)
    # preserve exit as the last option
    last = @options.pop
    @options << {label: label, callback: blk || -> (arg) {}}
    @options << last
  end

  # Public: Starts read-eval-print loop.
  def show
    while true do
      clear_screen
      print_screen
      get_input
    end
  rescue IOError
    # do nothing, program has ended
  end

  # Public: Quits this menu.
  def quit
    @stdin.close
    @stdout.close
  end

  private

    def go_down
      if @selected_index == @options.length - 1
        @selected_index = 0
      else
        @selected_index += 1
      end
    end

    def go_up
      if @selected_index == 0
        @selected_index = @options.length - 1
      else
        @selected_index -= 1
      end
    end

    def print_header
      print(@title.upcase)
      print(@description)
      print_delimiter
    end

    def print_options
      @options.each_with_index do |option, i|
        if i == @options.length - 1 # last option AKA exit
          print_delimiter
          print("#{option[:label].upcase}", inverted: i == @selected_index)
        else
          print(">> #{option[:label].upcase}", inverted: i == @selected_index)
        end
      end
    end

    def print_delimiter
      print('-' * @width)
    end

    def print_screen
      print_header
      print_options
    end

    def print(text, inverted: false)
      if inverted
        @stdout.puts Paint[text.ljust(@width), @bg, @fg]
      else
        @stdout.puts Paint[text.ljust(@width), @fg, @bg]
      end
    end

    def get_input
      char = @stdin.getch

      @last_char << char # special characters (like up arrow) get sent
                         # as mulitple characters, so we have to store past
                         # few characters somewhere

      case
      when @last_char.join == "\e[A" || char == 'k' # up arrow or k
        go_up
        @last_char = []
      when @last_char.join == "\e[B" || char == 'j' # down arrow or j
        go_down
        @last_char = []
      when char == "\r" # enter
        if @selected_index == @options.length - 1
          quit
          return
        end

        @options[@selected_index][:callback].call(@options[@selected_index][:label])
        @selected_callback.call(@options[@selected_index][:label])
      when char == "\u0003" || char == "q" # ctrl+c or q
        quit
      when !@last_char.include?("\e") # not a special character, clear array
        @last_char = []
      end
    end

    def clear_screen
      @stdout.puts "\e[0m"
      @stdout.puts "\e[2J"
      @stdout.puts "\ec"
    end
end
