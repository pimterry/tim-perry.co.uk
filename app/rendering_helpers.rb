require 'hpricot'
require 'RedCloth'
require 'coderay'

def render_textile textile
  html = RedCloth.new(textile,
                      [:filter_html,
                       :filter_classes,
                       :filter_styles,
                       :filter_ids] ).to_html

  doc = Hpricot.parse(html)
  (doc/:code).each do |code_block|
    if code_block.has_attribute? 'lang' then
      lang = code_block.attributes['lang']
      code = code_block.inner_html
      # Leading newlines always end up making everything messy, just strip them
      if code[0] == "\n" then
        code.slice! 0
      end
      code_block.inner_html = CodeRay.scan(code, lang).html(:css => :class)
    end
  end

  return doc.to_html
end
