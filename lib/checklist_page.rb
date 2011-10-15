require 'erector'
require 'doc_page'

class ChecklistPage < DocPage

  def initialize options
    super
    @step_stack = []
  end

  def next_step
    @step_stack << 0 if @step_stack.empty?
    @step_stack[-1] = @step_stack.last + 1
  end

  def step name = nil
    h2 do
      text "Step #{next_step}: "
      text name
    end
    yield if block_given?
  end

  def option name
    h2 do
      text "Option #{next_step}: "
      text name
    end
    if block_given?
      blockquote do
        @step_stack.push 0
        yield # if block_given?
        @step_stack.pop
      end
    end

  end

  def choice name = "between"
    step "Choose #{name}" do
      blockquote do
        @step_stack.push 0
        yield # if block_given?
        @step_stack.pop
      end
    end
  end

  def note text
    p raw(md2html text)
  end

  def verify text = nil
    h2 "Step #{next_step}: Verify #{text}"
    blockquote do
      yield
    end
  end

  def console text
    p do
      text "Type this on the console:"
      pre text
    end
  end

  def result text
    p do
      text "Expected result:"
      pre text
    end
  end

  def doc_content
    eval src, binding, @doc_path, 1
  end
end
