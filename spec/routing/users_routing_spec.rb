# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for users', type: :routing do
  describe 'routing' do
    it 'to #index' do
      expect(get: 'api/v1/users').to route_to('api/v1/users#index')
    end

    it 'to #show' do
      expect(get: 'api/v1/users/1').to route_to('api/v1/users#show', id: '1')
    end

    it 'to #update' do
      expect(put: 'api/v1/users/1').to route_to('api/v1/users#update', id: '1')
    end

    it 'to #friend_list' do
      expect(get: 'api/v1/users/friends').to route_to('api/v1/users#friend_list')
    end

    it 'to #friend_names' do
      expect(get: 'api/v1/users/friends-name')
        .to route_to('api/v1/users#friend_names')
    end

    it 'to #search_profile' do
      expect(get: 'api/v1/users/search-profile')
        .to route_to('api/v1/users#search_profile')
    end

    it 'to #email-verify' do
      expect(patch: 'api/v1/users/email-verify/token')
        .to route_to('api/v1/users#email_verification', token: 'token')
    end
  end
end
