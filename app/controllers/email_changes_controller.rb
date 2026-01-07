class EmailChangesController < ApplicationController
  before_action :authenticate_user!, except: :confirm

  def new; end

  def create
    new_email = EmailNormalizer.call(params.require(:email_change).fetch(:new_email))

    if User.where(email: new_email).exists? || EmailChangeRequest.where(new_email: new_email).exists?
      redirect_to new_email_change_path, alert: "That email address is already in use"
    else
      request = current_user.email_change_requests.create!(new_email: new_email)
      UserMailer.with(request: request).email_change_confirmation.deliver_later
      redirect_to user_profile_path, notice: "We've sent a confirmation link to the new email address"
    end
  end

  def confirm
    request = EmailChangeRequest.find_by!(token: params[:token])

    if request.expired?
      request.destroy
      redirect_to root_path, alert: "That confirmation link has expired"
    elsif User.where(email: request.new_email).where.not(id: request.user_id).exists?
      request.destroy
      redirect_to root_path, alert: "That email address is already in use"
    else
      request.user.update!(
        email: request.new_email,
        email_confirmed_at: Time.current
      )

      request.user.email_change_requests.delete_all
      redirect_to user_profile_path, notice: "Your email address has been updated"
    end
  end
end
