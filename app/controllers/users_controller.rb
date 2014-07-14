class UsersController < ApplicationController

  #before_filter :check_password , only: [:edit, :update]
  skip_before_filter :check_password_authenticated, :only => [:password, :update_password]

  # Edit particular user details
  def edit
    @user = current_user
    @user.build_profile unless @user.profile.present?
  end

  #
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:notice] = "User updated successfully."
      redirect_to edit_user_path
    else
      flash[:error] = @user.errors[:"attachment.file_size_exceeds"][0]
      render "edit"
    end
  end

  def password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_attributes(password_params)
      # Sign in the user by passing validation in case his password changed
      sign_in(@user, :bypass => true)
      redirect_to root_subdomain_path
    else
      render "password"
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :user_name, :full_name, :timezone, :language_id, profile_attributes: [:id, :personal_email, :user_id, :phone_no, :address1, :address2, :city, :state, :country_id, :_destroy], attachment_attributes: [:id, :attachment_file, :file_size,:company_id])
  end

  def password_params
    params.require(:users).permit(:password, :password_confirmation)
  end
end
