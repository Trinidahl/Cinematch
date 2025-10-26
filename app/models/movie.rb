require 'open-uri'
require 'nokogiri'
require 'cloudinary'

class Movie < ApplicationRecord
  has_many :recommendations
  has_many :chats, through: :recommendations

  has_one_attached :poster

  validates :title, uniqueness:

  after_create :attach_poster

  private

  def attach_poster
    return if poster.attached?
    return if url.blank?

    html = URI.open(self.url, "Accept-Language" => "en-US", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36")
    html_doc = Nokogiri::HTML.parse(html)

    # recherche le code css correspondant, prend le premier et prend l'image associee
    poster = html_doc.at_css(".ipc-media--poster-l img")
    # on récupère l'URL de l'image qui est dans src
    poster_src = poster['src']

    # https://guides.rubyonrails.org/active_storage_overview.html#attaching-file-io-objects
    file = URI.open(poster_src)
    self.poster.attach(
      io: file,
      filename: "#{title.parameterize}.jpg",
      content_type: "image/jpeg"
    )
  end
end
