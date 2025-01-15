class Video < ApplicationRecord
  acts_as_tenant :organization

  has_one_attached :file, dependent: :destroy

  # validate :file_validation

  private

  def file_validation
    if file.attached?
      # Validate file size
      if file.blob.byte_size > 50.megabytes
        errors.add(:file, "size must be less than 50 MB")
      end

      # # Validate file type
      # acceptable_types = ["video/mp4", "video/mkv"]
      # unless acceptable_types.include?(file.blob.content_type)
      #   errors.add(:file, "must be a MP4 or MKV video")
      # end
    else
      errors.add(:file, "must be attached")
    end
  end
end
