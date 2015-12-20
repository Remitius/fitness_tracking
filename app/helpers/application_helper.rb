module ApplicationHelper
  def page_title(title)
    base = "Tracking"
    return base if title.empty?
    base + " | " + title
  end

  def remove_extraneous_decimal(num)
    (num % 1 == 0) ? num.to_i : num
  end

  def generate_header_link_list_item(display_text, url)
    flag = false
    anchor = link_to_unless_current(display_text, url) do
      flag = true
      link_to(display_text, '#')
    end
    li = flag ? "<li class='active'>#{anchor}</li>" : "<li>#{anchor}</li>"
    li.html_safe
  end

end