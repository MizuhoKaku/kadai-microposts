module UsersHelper
    def gravatar_url(user, options = { size: 80})
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
       # ::Rails.logger.debug(gravatar_id) 
       # ::Rails.logger.debug(user.email.downcase)
        "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
end
