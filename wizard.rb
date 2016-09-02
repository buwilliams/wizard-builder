def ask_question(question, data)
  print "#{question.call(data)}: "
  return gets.chomp
end

def do_action(action, data)
  return action.call(data)
end

def do_levels(levels)
  data = []

  # levels = levels.sort_by { |hsh| hsh[:level] }
  index = 0
  current_level = 0

  loop do
    break unless index
    q = levels[index]

    if q[:type] == 'question' and q[:level] == current_level and q[:condition].call(data)
      data.push(ask_question(q[:question], data))
      current_level += 1
      index = levels.index {|h| h[:level] == current_level }
    elsif q[:type] == 'action' and q[:level] == current_level and q[:condition].call(data)
      data.push(do_action(q[:action], data))
      current_level += 1
      index = levels.index {|h| h[:level] == current_level }
    elsif q[:type] == 'goto' and q[:level] == current_level and q[:condition].call(data)
      if q[:action]
        data.push(do_action(q[:action], data))
      end
      current_level = q[:goto]
      index = levels.index {|h| h[:level] == current_level }
    else
      index += 1
    end
  end

  2.times { puts }
  puts "Data inspection:"
  puts data.inspect
end

levels = [
  {
    level: 0,
    type: 'question',
    question: -> (data) { "What is your first name?" },
    condition: -> (data) { true }
  },
  {
    level: 1,
    type: 'question',
    question: -> (data) { "What is your last name, #{data[-1]}?" },
    condition: -> (data) { true }
  },
  {
    level: 2,
    type: 'question',
    question: -> (data) { "Enter a different first name?" },
    condition: -> (data) { true }
  },
  {
    level: 3,
    type: 'question',
    question: -> (data) { "Enter a different last name?" },
    condition: -> (data) { true }
  },
  {
    level: 4,
    type: 'goto',
    goto: 0,
    action: -> (data) { puts "Those were the same names. Let's start over... sigh." },
    condition: -> (data) { data[-1] == data[-3] and data[-2] == data[-4] }
  },
  {
    level: 4,
    type: 'action',
    action: -> (data) { puts "Nice work!" },
    condition: -> (data) { true }
  }
]

do_levels(levels)
