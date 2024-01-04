class Comment < ApplicationRecord
    acts_as_paranoid
    belongs_to :article
    belongs_to :user
end