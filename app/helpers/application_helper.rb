module ApplicationHelper
  def page_title(title)
    base = "Tracking"
    return base if title.empty?
    base + " | " + title
  end

  def remove_extraneous_decimal(num)
    (num % 1 == 0) ? num.to_i : num
  end
end