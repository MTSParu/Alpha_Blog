class User < ApplicationRecord
    before_save { self.email = email.downcase }
    has_many :articles, dependent: :destroy
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 3, maximum: 25}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\z\-.]+\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }
    has_secure_password
    has_many :comments
    has_one_attached :profile_image
    validate :acceptable_image

    def acceptable_image
        return unless profile_image.attached?
        
        unless profile_image.blob.byte_size <= 2.megabyte
            errors.add(:profile_image, "Profile size is Greater Than 2..Magabytes")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_image.content_type)
            errors.add(:profile_image, "must be a JPEG or PNG")
        end
    end
end
