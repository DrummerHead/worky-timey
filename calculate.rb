require "./timesheet"

# Define rate and currency kind
#
worked_time = []
@rate = 60
currency = 'USD'


# Convert time string to minutes integer
#
def hours_to_mins(time)
  time_inspect = time.split(':')
  mins = time_inspect[0].to_i * 60 + time_inspect[1].to_i
end


# Calculate total min worked, optionally return as hours
#
def worked_mins(step, hours = false)
  start_m = hours_to_mins(step[:start])
  finish_m = hours_to_mins(step[:finish])
  substract_m = hours_to_mins(step[:substract])
  worked_m = finish_m - start_m - substract_m
  return hours ? worked_m / 60.0 * step[:multiplier] : worked_m * step[:multiplier]
end


# Churn data, puts Markdown
#
@timesheet.each do |date, data|
  puts "\n\n#{date.to_s.gsub('d', '')}\n=========="

  data.each do |step|
    puts step[:description].gsub(/^ */, '')
    worked_time << worked_mins(step)
    puts "__#{worked_mins(step, true)} hours__"
  end
end


# Grand total calculation
#
total_worked_time = worked_time.reduce(:+)
total_worked_time_in_hours = total_worked_time / 60.0
pay_total = total_worked_time * @rate / 60.0

puts "\n\nTotal\n=====\n"
puts "#{total_worked_time}min worked = #{total_worked_time_in_hours} hours"
puts "At #{@rate} #{currency} per hour is:"
puts "__#{pay_total} #{currency}__"
