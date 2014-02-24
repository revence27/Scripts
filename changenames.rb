#!  /usr/bin/env  ruby
#
# Given a Zefania XML file, change the names of the books.
#

require 'xpro'

include Xpro

def cmain args
  all args do |_, doc|
    doc.xpath('/XMLBIBLE/BIBLEBOOK').each do |book|
      $stdout.puts("Change \x1b[7m%s\x1b[0m to:" % book['bname'])
      book['bname'] = $stdin.gets.strip
    end
    $stdout.puts "New destination path:"
    path  = $stdin.gets.strip
    if path.empty? then
      IO.popen 'less', 'w' do |pipe|
        pipe.write doc.to_s
      end
    else
      File.open(path, 'w') do |fch|
        fch.write doc.to_s
      end
    end
  end
  0
end

exit(cmain(ARGV))
