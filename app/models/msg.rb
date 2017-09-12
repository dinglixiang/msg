class Msg < ApplicationRecord
  enum status: { unread: 0, readed: 1, removed: 2 }

  def info
    slice(:id, :status, :content).merge(created_at: created_at.to_i)
  end

  def self.valid_statuses
    statuses.values_at(:unread, :readed)
  end
end
