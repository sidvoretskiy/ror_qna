class Question < ActiveRecord::Base
  has_many :answers,  dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id,  presence: true
  validates :title, length: {maximum: 200}

  accepts_nested_attributes_for :attachments

end
