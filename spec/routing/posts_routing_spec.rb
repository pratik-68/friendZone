# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for posts', type: :routing do
  describe 'routing' do
    it 'to #index' do
      expect(get: 'api/v1/posts').to route_to('api/v1/posts#index')
    end

    it 'to #show' do
      expect(get: 'api/v1/posts/1').to route_to('api/v1/posts#show', id: '1')
    end

    it 'to #update' do
      expect(put: 'api/v1/posts/1').to route_to('api/v1/posts#update', id: '1')
    end

    it 'to #create' do
      expect(post: 'api/v1/posts').to route_to('api/v1/posts#create')
    end

    it 'to #friend_posts' do
      expect(get: 'api/v1/posts/friends').to route_to('api/v1/posts#friend_posts')
    end

    it 'to #user_posts' do
      expect(get: 'api/v1/posts/users/1')
        .to route_to('api/v1/posts#user_posts', id: '1')
    end
  end
end
