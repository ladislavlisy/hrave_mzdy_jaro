module ApplicationHelper
  def title

    # return title on a per-page basis.
    base_title = "Hrave Mzdy - platova a mzdova agenda"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
