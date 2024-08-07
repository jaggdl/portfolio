class Post < ApplicationRecord
  include Visibility

  extend FriendlyId
  friendly_id :title, use: :slugged

  extend Mobility
  translates :title, type: :string
  translates :markdown, :description, type: :text
  translates :og_image, type: :string

  mount_uploader :image, PostImageUploader
  mount_uploader :og_image, PostOgImageUploader

  with_options presence: true do
    validates :title
    validates :markdown
    validates :description
    validates :image
  end

  def markdown_to_html
    @markdown ||= Redcarpet::Markdown.new(
      MarkdownRendererWithSpecialLinks,
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true
    )
    @markdown.render(markdown).html_safe
  end

  OG_IMAGE_DIMENSIONS = {
    width: 1200,
    height: 630
  }.freeze

  def enqueue_og_image_generation
    OgImageGeneratorJob.perform_later(self.id)
  end

  def translated?
    title.present? && markdown.present? && description.present?
  end

  def total_unique_views
    Ahoy::Event.where(
      name: 'Viewed Post',
      properties: { post_id: self.id.to_s }
    ).distinct.count(:visit_id)
  end

  def preview_image
    img = image.md

    {
      avif: img.avif.url,
      webp: img.webp.url,
      url: img.url,
    }
  end
end
