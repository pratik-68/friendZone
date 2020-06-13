# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    FactoryBot.create(:user)
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a first_name' do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid for first_name length greater than 20' do
      subject.first_name = 'charactergreatherthantwenty'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a last_name' do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid for last_name length greater than 20' do
      subject.last_name = 'charactergreatherthantwenty'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid for username length greater than 20' do
      subject.username = 'charactergreatherthantwenty'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'invalid email format1' do
      subject.email = 'example@example'
      expect(subject).to_not be_valid
    end

    it 'invalid email format2' do
      subject.email = 'e@e.i'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a gender' do
      subject.gender = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a date_of_birth' do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid for date_of_birth less than 18 years' do
      subject.date_of_birth = Date.current - 17.years
      expect(subject).to_not be_valid
    end

    it 'is valid for blank city' do
      subject.city = ''
      expect(subject).to be_valid
    end

    it 'is not valid for city length greater than 20' do
      subject.city = 'charactergreatherthantwenty'
      expect(subject).to_not be_valid
    end

    it 'is not valid for city length less than 3' do
      subject.city = 'aa'
      expect(subject).to_not be_valid
    end

    it 'is not valid for same email' do
      FactoryBot.create(:user)
      user_one = FactoryBot.build(:user,
                                  username: 'test1233',
                                  email_verification_token: 'token2')
      expect(user_one).to_not be_valid
    end

    it 'is not valid for same username' do
      FactoryBot.create(:user)
      user_one = FactoryBot.build(:user,
                                  email: 'test1@example.com',
                                  email_verification_token: 'token2')
      expect(user_one).to_not be_valid
    end

    it 'is not valid for same token' do
      FactoryBot.create(:user)
      user_one = FactoryBot.build(:user,
                                  username: 'test1233',
                                  email: 'test1@example.com')
      expect(user_one).to_not be_valid
    end

    it { should have_secure_password }
    it { should validate_confirmation_of(:password) }
    it { is_expected.to define_enum_for(:gender).with_values(%w[male female other]) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:email_verification_token) }
    it { should validate_uniqueness_of(:reset_password_token) }
  end

  describe 'Associations' do
    it { should have_many(:post_users) }
    it { should have_many(:login_tokens) }
    it { should have_many(:posts) }
    it { should have_many(:requests) }
  end

  describe 'Methods' do
    it 'check valid friends retrieving' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      friend1 = FactoryBot.create(:friend,
                                  user1_id: user1.id,
                                  user2_id: user2.id,
                                  requester_id: user1.id)
      friend2 = FactoryBot.create(:friend,
                                  user1_id: user2.id,
                                  user2_id: user3.id,
                                  requester_id: user3.id)
      expect(user2.friends).to include(friend1, friend2)
    end

    it 'check invalid friends not retrieving type 1' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id)
      friend2 = FactoryBot.create(:friend,
                                  user1_id: user2.id,
                                  user2_id: user3.id,
                                  requester_id: user3.id)
      expect(user1.friends).to_not include(friend2)
    end

    it 'check invalid friends not retrieving type 2' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      friend1 = FactoryBot.create(:friend,
                                  user1_id: user1.id,
                                  user2_id: user2.id,
                                  requester_id: user1.id)
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id)
      expect(user3.friends).to_not include(friend1)
    end

    it 'check valid friends user object retrieving' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id)
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id)
      expect(user2.friend_users.map(&:id)).to_not include(user1.id, user3.id)
    end

    it 'check invalid friends users not retrieving type 1' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id)
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id)
      expect(user1.friend_users).to_not include(user3)
    end

    it 'check invalid friends users not retrieving type 2' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id)
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id)
      expect(user3.friend_users).to_not include(user1)
    end

    it 'check valid friends user object where notification on retrieving' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id,
                        status: 'accepted',
                        notifications: 'to_first')
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id,
                        status: 'accepted',
                        notifications: 'to_second')
      expect(user2.notification_receipients).to include(user1, user3)
    end

    it 'check invalid friends users not retrieving where notification off type 1' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user2.id,
                        requester_id: user1.id,
                        status: 'accepted',
                        notifications: 'to_second')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user3.id,
                        requester_id: user3.id,
                        status: 'accepted',
                        notifications: 'to_none')
      expect(user1.notification_receipients).to_not include(user3)
    end

    it 'check invalid friends users not retrieving where notification off type 2' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user,
                                username: 'test1233',
                                email: 'test1@example.com',
                                email_verification_token: 'token2')
      user3 = FactoryBot.create(:user,
                                username: 'test321',
                                email: 'test4@example.com',
                                email_verification_token: 'token4')
      FactoryBot.create(:friend,
                        user1_id: user1.id,
                        user2_id: user3.id,
                        requester_id: user1.id,
                        status: 'accepted',
                        notifications: 'to_first')
      FactoryBot.create(:friend,
                        user1_id: user2.id,
                        user2_id: user3.id,
                        requester_id: user3.id,
                        status: 'accepted',
                        notifications: 'to_none')
      expect(user3.notification_receipients).to_not include(user2)
    end
  end
end
