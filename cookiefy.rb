#!  /usr/bin/env ruby

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
