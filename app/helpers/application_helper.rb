module ApplicationHelper
  def page_title(title)
    base = "Tracking"
    return base if title.empty?
    base + " | " + title
  end
end