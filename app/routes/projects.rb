class TimPerryApp < Sinatra::Base
  get '/projects' do
    placeholder = Paragraph.new("Work in progress",
                                "<p>Alright, alright, this bit's not done yet. Patience please!</p>")

    haml :template, :locals => { :title => 'Projects',
                                 :paragraphs => [placeholder] }
  end
end