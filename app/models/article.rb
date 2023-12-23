class Article < ApplicationRecord
    validates :title, presence: true, length: {minimum: 6, maximum: 100 }
    validates :sub_title, presence: true, length: {minimum: 3, maximum: 5 }
    validates :description, presence: true, length: { minimum: 10, maximum: 300}
    has_many :comments
end