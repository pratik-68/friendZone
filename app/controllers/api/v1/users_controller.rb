# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:email_verification]
  serialization_scope :current_user

  def index
    success_response(json_data: current_user)
  end

  def search_profile
    unless params[:username].present?
      return bad_response(message: 'cant be blank')
    end

    page = params.fetch(:page, 1).to_i

    return bad_response(message: 'Invalid Request') unless page.positive?

    username = params[:username]
    users = filter(
      record: User.where('username ILIKE ?', "%#{username}%"),
      page: page,
      order: %i[first_name last_name]
    )
    count = User.where('username ILIKE ?', "%#{username}%")
                .count

    success_response(json_data: users, meta_data: { total_count: count })
  end

  def update
    user = User.find_by(id: params[:id])

    return forbidden_response unless user.present?

    authorize user

    if user_update_params[:password].present?
      old_password = user_old_password[:old_password]

      unless old_password.present?
        return bad_response(old_password: 'Old Password can\'t be blank')
      end
      unless current_user.authenticate(old_password)
        return bad_response(old_password: 'Invalid Old Password')
      end
    end

    if current_user.update(user_update_params)
      success_response
    else
      bad_response(current_user.errors)
    end
  end

  def show
    profile_user = User.find_by(id: params[:id])

    return not_found_response unless profile_user.present?

    success_response(json_data: profile_user)
  end

  def email_verification
    user = User.find_by(email_verification_token: params[:token])
    return bad_response(message: 'Invalid Link') unless user.present?
    return bad_response(email: 'Email already active') if user.is_verified?

    user.update(is_verified: true)
    success_response
  end

  def friend_list
    page = params.fetch(:page, 1).to_i

    return bad_response(message: 'Invalid Request') unless page.positive?

    users = filter(
      record: current_user.friend_users,
      page: page,
      order: %i[first_name last_name]
    )
    count = current_user.friend_users.count

    success_response(json_data: users, meta_data: { total_count: count })
  end

  def friend_names
    users = filter(
      record: current_user.friend_users,
      order: %i[first_name last_name]
    )

    success_response(json_data: users)
  end

  private

  def user_update_params
    params.require(:user).permit(
      :first_name, :last_name, :gender, :city, :date_of_birth,
      :password, :password_confirmation, :interests
    )
  end

  def user_old_password
    params.require(:password).permit(:old_password)
  end
end
