# encoding: utf-8

module ApplicationHelper
  def title

    # return title on a per-page basis.
    base_title = "Hravé Mzdy - online platová a mzdová agenda"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
