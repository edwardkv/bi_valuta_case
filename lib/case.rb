require 'net/http'
require 'uri'
require 'rexml/document'

#находим баланс портфеля
# 0  - сбалансирован
# > 0 - купить usd
# < 0 - продать usd
def balance(usd, rub, rate)
  difference_rub = (rub - usd * rate) / 2
  balance = difference_rub / rate

  if balance.abs < 0.01
    return 0
  end

  return balance.round(2)
end

#интерпратация баланса
def balance_interptetation(balance)
  if balance == 0
    "Ничего менять не нужно"
  elsif balance > 0
    "Вам нужно купить #{balance} долларов"
  else
    "Вам нужно продать #{balance.abs} долларов"
  end
end

#курс доллара
def get_rate_usd
  rate = 0
  error_rate = false
  error_status = ""

  begin
    uri = URI.parse('http://www.cbr.ru/scripts/XML_daily.asp')
    response = Net::HTTP.get_response(uri)
    doc = REXML::Document.new(response.body)
    # R01235 — Доллар США
    rate = doc.get_elements('//Valute[@ID="R01235"]').first.get_text('Value').to_s.tr(',', '.').to_f
  rescue SocketError #сеть недоступна
    error_status =  "Не могу соединиться с сервером. "
    error_rate = true
  rescue #другие ошибки, если сервер доступен, а в данных ошибки
    error_status =  "Ошибка при получении курса. "
    error_rate = true
  end

  {rate: rate, error_rate: error_rate, error_status: error_status}
end
