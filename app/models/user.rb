class User < ApplicationRecord

  has_secure_password

  CONFIRMATION_TOKEN_VALIDITY = 1.hour

  # token_type is:
  # confirmation for confirmation_token,
  # password_reset for password_reset_token
  # etc.
  def generate_token_and_send_instructions!(token_type:)
    generate_token(:"#{token_type}_token")
    self[:"#{token_type}_sent_at"] = Time.now.utc
    save!
    UserMailer.with(user: self).send(:"email_#{token_type}").deliver_later
  end

  def confirmation_token_expired?
    (Time.now.utc - self.confirmation_sent_at) > CONFIRMATION_TOKEN_VALIDITY
  end

  def forget_me!
    return unless persisted?
    self.remember_token = nil
    save(validate: false)
  end

  def generate_token(column)
    loop do
      token = friendly_token
      self[column] = token
      break token unless User.exists?(column => token)
    end
  end

  # Generate a friendly string randomly to be used as token.
  # By default, length is 20 characters.
  private def friendly_token(length = 20)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end

end