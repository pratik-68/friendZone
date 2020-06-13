# frozen_string_literal: true

module Response
  extend ActiveSupport::Concern

  def success_response(json_data: {}, meta_data: {})
    render(json: json_data, meta: meta_data, status: 200)
  end

  def create_response(json_data = {})
    render(json: json_data, status: 201)
  end

  def bad_response(json_data)
    render(json: { error: json_data }, status: 400)
  end

  def unauthorized_response(json_data = { error: { message: 'Please log in' } })
    render(json: json_data, status: 401)
  end

  def forbidden_response(json_data = { error: { message: 'Not Allowed' } })
    render(json: json_data, status: 403)
  end

  def not_found_response(json_data = { error: { message: 'Not Found' } })
    render(json: json_data, status: 404)
  end
end
