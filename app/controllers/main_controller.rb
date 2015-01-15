# -*- encoding : utf-8 -*-
class MainController < ApplicationController
  def index
    unless params[ :locale]
      # it takes I18n.locale from the previous example set_locale as before_filter in application controller
      redirect_to eval("root_#{I18n.locale}_path")
    end

  end

  def help
  end

  def about
  end

  def board

  end

  def contact
    @contact = Contact.new
  end

  def rules
  end

  def partners
  end

  def send_email
    @contact = Contact.new params[:contact]
    if @contact.valid?
      ActionMailer::Base.mail(
          from: @contact.email, :to => 'contact@collaide.com',
          subject: @contact.subject,
          body: @contact.content
      ).deliver
      redirect_to contact_path, notice: t('static_pages.contact.success', email: @contact.email, subject: @contact.subject)
    else
      render action: :contact
    end
  end

  def mail_test
    @message = Message.find 1

    render template: 'message_mailer/new_message_email'
  end
end
