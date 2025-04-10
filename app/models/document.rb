class Document < ApplicationRecord
  has_one_attached :markdown_file
  # validates :markdown_file, content_type: [ "text/markdown", "text/plain" ], allow_nil: true

  include PgSearch::Model
  pg_search_scope :search_full_text, against: [ :title, :content ],
                  using: {
                    tsearch: { prefix: true }
                  }
end
