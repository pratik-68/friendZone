# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for friends', type: :routing do
  describe 'routing' do
    it 'to #email_request_accept' do
      expect(patch: 'api/v1/friends/request-verify/token')
        .to route_to('api/v1/friends#email_request_accept', token: 'token')
    end

    it 'to #subscribe' do
      expect(patch: 'api/v1/friends/subscribe/1')
        .to route_to('api/v1/friends#subscribe', id: '1')
    end

    it 'to #update' do
      expect(patch: 'api/v1/friends/request/1')
        .to route_to('api/v1/friends#update', id: '1')
    end

    it 'to #create' do
      expect(post: 'api/v1/friends/request/1')
        .to route_to('api/v1/friends#create', id: '1')
    end
  end
end
