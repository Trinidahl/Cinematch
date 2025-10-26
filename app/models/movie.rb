require 'open-uri'
require 'nokogiri'
require 'cloudinary'

class Movie < ApplicationRecord
  has_many :recommendations
  has_many :chats, through: :recommendations

  after_create :attach_poster

  private

  def attach_poster
    url = self.url
    html = URI.open(url)
    html_doc = Nokogiri::HTML.parse(html)
    # recherche le code css correspondant, le premier et prend l'image
    poster = html_doc.at_css(".ipc-media--poster-l img")
    poster_src = poster['src'] # <-- on récupère l'URL de l'image qui est dans img
    puts poster_src
  end
end
