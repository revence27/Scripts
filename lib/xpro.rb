require 'nokogiri'

module Xpro
  # Deal with XML files d’un seul coup.
  def all *args
    x, them = if args.length == 1 then
      [nil, args.first]
    else
      [args.first, args.last]
    end
    them.inject x do |p, n|
      File.open n do |fch|
        doc = Nokogiri::XML fch.read
        if block_given? then
          yield p, doc
        else
          processor! doc
        end
      end
    end
  end
end
