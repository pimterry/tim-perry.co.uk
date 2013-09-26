class TimPerryApp < Sinatra::Base
  not_found do
    not_found_paragraph = Paragraph.new("Sorry! That doesn't seem to exist",
                                        textile(:'partials/404'))

    haml :template, :locals => { :title => "Not Found",
                                 :paragraphs => [ not_found_paragraph ] }
  end

  error do
    error_paragraph = Paragraph.new("Woah, something broke there, sorry",
                                    textile(:'partials/500'))
    haml :template, :locals => { :title => "Error",
                                 :paragraphs => [ error_paragraph ] }
  end
end
