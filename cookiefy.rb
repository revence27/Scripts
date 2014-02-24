#!  /usr/bin/env ruby
# Take two Zefania XML files and make a coloured fortune cookie database out of them,
# such that the second one is a translation of the first, and the cookies present
# the first one for language practice, and the second one for validating answers.
# To prevent cheating, the translation (the second one) is presented reversed
# (except for brackets).
#
# Cases of [such bracketing] in either source text is used to indicate a linguistic gloss
# and the fortune files preserve that.
# Meant for practicing languages with the help of Bible translations.

require 'nokogiri'

class String
  def treat init
    self.gsub(/\[([^\]]+)\]/) do |mtc|
      "\x1b[0m\x1b[2;33m#{$1}#{init}"
    end
  end

  def swap x, y, int = '≥'
    self.gsub(x, int).gsub(y, x).gsub(int, y)
  end
end

def cmain args
  left, right = args.map do |arg|
    File.open(arg) do |fch|
      Nokogiri::XML(fch.read).css('VERS').inject([]) do |p, n|
        p << n.text.gsub(/^`/, '“').gsub('`s', '’s').gsub(/(\s)`(\w)/, '\1“\2').gsub('`', '”').gsub(/\s*--\s*/, '—')
      end
    end
  end
  ans = left.map.with_index do |lit, ix|
    topinit = "\x1b[0m\x1b[7m"
    botinit = "\x1b[0m\e[1;31m"
    topinit + lit.treat(topinit) + (right ? ("\n" + botinit + (right[ix] || '').gsub('(', ')').gsub('[', ']').reverse.treat(botinit)) : '')
  end.join("\x1b[0m\n%\n")
  $stdout.puts ans
  0
end

exit(cmain(ARGV))
