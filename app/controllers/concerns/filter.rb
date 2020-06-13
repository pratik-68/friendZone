# frozen_string_literal: true

module Filter
  extend ActiveSupport::Concern

  def filter(record: {}, page: 1, per_page: 10, order: {})
    record.limit(per_page).offset((page - 1) * per_page).order(order)
  end
end
