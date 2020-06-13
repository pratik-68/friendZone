# frozen_string_literal: true

class PostSerializer < ApplicationSerializer
  attributes :id, :description, :image, :visible_to, :created_at
  attribute :owner
  has_one :user

  ## post image
  def image
    return unless object.image.attached?

    ## retrive image details from active storage
    object.image.blob.attributes
          .slice('filename', 'byte_size')
          .merge(url: image_url)
          .tap { |attrs| attrs['name'] = attrs.delete('filename') }
  end

  ## return url for object image
  def image_url
    url_for(object.image)
  end

  def owner
    object.user == current_user
  end
end
