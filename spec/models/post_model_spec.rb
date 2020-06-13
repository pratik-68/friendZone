# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject do
    user = FactoryBot.create(:user)
    described_class.new(description: 'Nes post',
                        visible_to: 'public',
                        user_id: user.id)
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a visible_to' do
      subject.visible_to = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:post_users) }
  end

  describe 'Methods' do
    it 'public post visible to random user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      post = FactoryBot.create(:post, user: user1, visible_to: 'public')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to include(post)
    end

    it 'friends post not visible to random user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      post = FactoryBot.create(:post, user: user1, visible_to: 'friends')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to_not include(post)
    end

    it 'friend post visible to friends' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id,
                        status: 'accepted')
      post = FactoryBot.create(:post, user: user1, visible_to: 'friends')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to include(post)
    end

    it 'personal post not visible to random user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      post = FactoryBot.create(:post, user: user1, visible_to: 'personal')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to_not include(post)
    end

    it 'personal post not visible to friend user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id,
                        status: 'accepted')
      post = FactoryBot.create(:post, user: user1, visible_to: 'personal')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to_not include(post)
    end

    it 'personal post not visible to friend user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id,
                        status: 'accepted')
      post = FactoryBot.create(:post, user: user1, visible_to: 'personal')
      visible_posts = Post.visible_posts(user2, user1)
      expect(visible_posts).to_not include(post)
    end
  end
end
