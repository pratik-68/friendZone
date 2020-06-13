# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name  { 'Doe' }
    email { 'test@example.com' }
    username { 'test1' }
    gender { 'male' }
    date_of_birth { '01-01-1995' }
    password_digest { 'password01' }
    email_verification_token { 'token1' }
    is_verified { false }
  end

  factory :friend do
    user1_id { '1' }
    user2_id { '2' }
    requester_id { '1' }
  end

  factory :post do
    user
    description { 'How to read a book effectively' }
    visible_to { 'public' }
  end
end
