#!  /usr/bin/env ruby
##  encoding: utf-8

require 'erb'
require 'nokogiri'

class Question
  attr_reader :text, :ref
  def initialize txt, r, anses
    @text     = txt
    @ref      = r
    @repos    = anses
  end

  def choices
    @repos.css('choice').map do |choice|
      choice.inner_html
    end
  end
end

class Section
  attr_reader :title
  def initialize nom, elm
    @title  = nom
    @elem   = elm
  end

  def questions
    @elem.css('item').map do |item|
      qn  = item.css('question').first
      Question.new(qn.inner_html, qn['ref'], item.css('answers').first)
    end
  end
end

class QBank
  attr_reader :name, :subject, :date
  def initialize str
    @doc      = Nokogiri::XML(str)
    @qbank    = @doc.css('questions').first
    @name     = @qbank['title'] or raise Exception.new('Please entitle the collection.')
    @subject  = @qbank['subject'] || 'General Knowledge'
    @date     = Time.mktime(*(@qbank['date'] || Time.now.strftime('%d/%m/%Y')).split('/').map {|x| x.to_i}.reverse)
  end

  def sections
    @qbank.css('section').map do |sec|
      Section.new(sec['title'], sec)
    end
  end
end

class School
  attr_reader :name, :address
  def initialize nom, ad
    @name     = nom
    @address  = ad
  end
end

def xmain args
  erb   =   ERB.new DATA.read
  args.each do |arg|
    File.open(arg) do |fch|
      book      = QBank.new fch.read
      school    = School.new 'Maberly', 'Plot 66, Dunstan Nsubuga Road,<br />Banga, Entebbe<br /><br />P. O. Box 738,<br />Entebbe, Uganda'
      time      = Time.now
      ans       = erb.result binding
      $stdout.puts ans
    end
  end
  0
end

exit(xmain(ARGV))

__END__
<!DOCTYPE html>
<html>
  <head>
    <title><%= book.name %> — <%= school.name %></title>
    <link rel="stylesheet" type="text/css" href="examl.css" />
    <script src="examl.js" type="text/javascript"></script>
  </head>
  <body>
    <div id="main">
      <div id="header">
        <div id="logo"><%=  school.name %></div>
        <div id="address"><%=  school.address %></div>
        <div id="course">
          <div id="subject"><%=  book.subject  %></div>
          <div id="period"><%=  book.date.strftime('%B')  %>, <%=  book.date.year %></div>
        </div>
        <div id="bktitle"><%=  book.name %></div>
        <div id="toc">
          <table>
            <tbody>
              <%  book.sections.each_with_index do |sec, six| %>
                <tr><td class="secnom"><%= sec.title %></td><td class="link"><a href="#sec<%= six %>"></a></td></tr>
              <%  end %>
            </tbody>
          </table>
        </div>
      </div>
      <div id="trunk">
        <%  book.sections.each_with_index do |sec, six| %>
        <div class="section">
          <h1 id="sec<%= six  %>"><%=  sec.title %></h1>
          <%  sec.questions.each do |qn| %>
            <div class="question"><%=  qn.text %><small class="ref"><%=  qn.ref  %></small></div>
            <ol>
              <%  qn.choices.each do |choice|  %>
              <li><%=  choice %></li>
              <%  end  %>
            </ol>
          <%  end  %>
        </div>
        <%  end  %>
      </div>
      <div id="index">
        <%  book.sections.each do |sec| %>
          <table>
            <thead>
              <tr>
                <th></th><th><%= sec.title %></th><th></th>
              </tr>
            </thead>
            <tbody>
              <%  sec.questions.each_with_index do |qn, ix| %>
                <tr><td class="qnum"><%= ix + 1  %></td><td><%=  qn.text %></td><td class="answerbox"></td></tr>
              <%  end %>
            </tbody>
          </table>
        <%  end %>
      </div>
      <div id="footer">
        &copy; <%= time.year %>, <%= school.name %>. All Rights Reserved.
      </div>
    </div>
  </body>
</html>
