require 'open-uri'
require 'nokogiri'
require 'cloudinary'

class Movie < ApplicationRecord
  has_many :recommendations
  has_many :chats, through: :recommendations

  has_one_attached :poster

  after_create :attach_poster

  private

  def attach_poster
    html = URI.open(self.url)
    html_doc = Nokogiri::HTML.parse(html)

    # recherche le code css correspondant, le premier et prend l'image
    poster = html_doc.at_css(".ipc-media--poster-l img")
    poster_src = poster['src'] # <-- on récupère l'URL de l'image qui est dans img

    file = URI.open(poster_src)
    poster.attach(
      io: file,
      filename: "#{title.parameterize}.jpg",
      content_type: "image/jpeg"
    )
    Rails.logger.info("Poster attaché pour #{title} via Cloudinary")
  end
end
