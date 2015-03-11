# -*- encoding : utf-8 -*-
class MainController < ApplicationController
  def index
    unless params[ :locale]
      # it takes I18n.locale from the previous example set_locale as before_filter in application controller
      redirect_to eval("root_#{I18n.locale}_path")
    end

    @group = Group::Group.new

    # if current_user
    #   # On va chercher les activités liés au membre
    #   @activities = current_user.activities.order("created_at desc").limit(20).includes(:trackable, :owner, :recipient)
    # else
    #   # Prendre que les activités publics
    #   @activities = Activity::Activity.order("created_at desc").public.limit(20).includes(:trackable, :owner, :recipient)
    # end

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
      ).deliver_later
      redirect_to contact_path, notice: t('main.contact.success', email: @contact.email, subject: @contact.subject)
    else
      render action: :contact
    end
  end
end
