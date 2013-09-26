require 'RedCloth'

class TimPerryApp < Sinatra::Base
  get '/about' do
    who_am_i = Paragraph.new("Who am I?",
                             textile(:'partials/about'))

    contact_me = Paragraph.new('<a name="contact" class="anchor">Want to talk to me?</a>',
                               textile(:'partials/contact'))

    haml :template, :locals => { :title => "About Me",
                                 :paragraphs => [who_am_i, contact_me] }
  end
end
