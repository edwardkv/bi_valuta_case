require_relative 'lib/case'

rate_hash = get_rate_usd
rate = rate_hash[:rate]

#если были ошибки спросим курс у пользователя
if rate_hash[:error_rate]
    puts rate_hash[:error_status]
    until rate > 0 do
      puts "Введите курс доллара"
      rate = gets.to_f
    end
end

puts "Курс доллара #{rate}"

puts "Сколько у вас рублей?"
rub = gets.to_f

puts "Сколько у вас долларов?"
usd = gets.to_f

usd_to_buy = balance(usd, rub, rate)
puts balance_interptetation(usd_to_buy)
