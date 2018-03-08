class Project < ApplicationRecord
  validates :title, :author_id, :body, presence: true

  belongs_to :user,
  class_name: :User,
  foreign_key: :author_id

  has_many :steps,
  class_name: :Project,
  foreign_key: :project_id

  has_attached_file :image, default_url: "missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
