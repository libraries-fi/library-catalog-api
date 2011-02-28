module ApplicationHelper
  def hilight(syntax, text)
    p text
    CodeRay.scan(text, syntax).div(:css => :class).html_safe
  end  
end
