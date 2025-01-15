module ApplicationHelper
  def is_active_link?(url, classes = nil, exempt = [])
    if classes.nil?
      return request.path == url
    end
    classes.include?(controller.controller_name) && !exempt.include?(controller.action_name)
  end

  # def cloudinary_url_for(blob, options = {})
  #   return nil unless blob.present?

  #   type = blob.content_type.split("/").first.eql?("video") ? "video" : "raw"
  #   format = type.eql?("video") ? "mp4" : "mov"
  #   # Default options with ability to override
  #   default_options = {
  #     resource_type: blob.content_type.split("/"),
  #     format: format
  #   }

  #   # Merge default options with any provided options
  #   cloudinary_options = default_options.merge(options)

  #   # Use Cloudinary's URL generation
  #   Cloudinary::Utils.cloudinary_url(
  #     blob.key,
  #     cloudinary_options
  #   )
  # rescue StandardError => e
  #   Rails.logger.error "Cloudinary URL generation error: #{e.message}"
  #   nil
  # end
end
