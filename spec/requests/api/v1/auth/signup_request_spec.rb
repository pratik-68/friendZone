# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Signups', type: :request do
  describe 'POST #signup' do
    it do
      signup_params = {
        user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'johndoe@example.com',
          password: 'password',
          password_confirmation: 'password',
          username: 'test1',
          gender: 'male',
          date_of_birth: '01-01-1995'
        }
      }
      should permit(:first_name, :last_name, :gender, :city, :date_of_birth,
                    :email, :username, :password, :password_confirmation,
                    :interests, :profile_pic)
        .for(:signup, verb: :post, params: signup_params).on(:user)
    end

    it 'create a user' do
      post '/widgets', params: { widget: { name: 'My Widget' } },
                       headers: headers
      expect(response).to have_http_status(:created)
      expect_any_instance_of(User).to receive(:signup)
      post :signup, session: { user: params }
      expect(assigns(:user)).to eq([user])
    end
  end
end
