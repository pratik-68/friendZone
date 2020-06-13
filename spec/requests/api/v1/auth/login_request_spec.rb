# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Logins', type: :request do
  describe 'POST #login' do
    it do
      login_parameter = {
        user: {
          email: 'johndoe@example.com',
          password: 'password'
        }
      }
      should permit(:email, :password)
        .for(:login, verb: :post, params: login_parameter).on(:user)
    end

    it 'assigns a user' do
      user = User.create
      post :login,
      expect(assigns(:user)).to eq([user])
    end
  end
end
