#!/usr/bin/env ruby

=begin
  Алгоритм:
  0) Валидируем все символы - если всетречаются символы с ASCII кодами < 'A' - пароля не будет
  1) Повышем регистр символов
  2) Суммируем ASCII коды всех символов
  3) XOR суммы кодов | 5678h | 1234h
  4) В цикле делим на 0Ah, к остатку от деления прибавляем 30h - это будет код символа
  5) Коды символов конкатенируем в обратном порядке
=end

ASCII_MIN_VALUE = 0x41
ASCII_DOWNCASE_THRESHOLD = 0x5A
ASCII_DOWNCASE_VALUE = 0x20
BYTES_XOR_VALUE = 0x5678 ^ 0x1234
BYTES_DIV_VALUE = 0x0A
ASCII_CODE_COMP = 0x30

if ARGV.empty?
  puts "Usage: #{__FILE__} <login>"

  exit(0)
end

login = ARGV.shift

is_valid = login.chars.reduce(true) { |res, char| (char.ord >= ASCII_MIN_VALUE) && res }

unless is_valid
  puts "LOGIN INCORRECT"
  puts "LOGIN must be ASCII symbols with codes >= 41"

  exit(0)
end

upcase_login = login.chars.map do |char|
  char.ord >= ASCII_DOWNCASE_THRESHOLD ? (char.ord - ASCII_DOWNCASE_VALUE).chr : char
end.join

login_hash = upcase_login.bytes.sum ^ BYTES_XOR_VALUE

pass = ""
while login_hash != 0
  login_hash, code = login_hash.divmod(BYTES_DIV_VALUE)
  pass.prepend((code + ASCII_CODE_COMP).chr)
end

puts "Your pass: #{pass}"
