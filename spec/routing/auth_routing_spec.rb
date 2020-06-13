# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for authorisation', type: :routing do
  describe 'routing' do
    it 'to #signup' do
      expect(post: 'api/v1/auth/signup').to route_to('api/v1/auth/signup#signup')
    end

    it 'to #login' do
      expect(post: 'api/v1/auth/login').to route_to('api/v1/auth/login#login')
    end

    it 'to #logout' do
      expect(delete: 'api/v1/auth/logout').to route_to('api/v1/auth/login#logout')
    end
  end
end
