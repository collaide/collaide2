class Devise::MailerPreview < ActionMailer::Preview

  def unlock_instructions
    Devise::Mailer.unlock_instructions(User.first, "faketoken")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "faketoken")
  end

end