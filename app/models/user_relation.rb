class UserRelation < ApplicationRecord
  enum status: { normal: 0, removed: 1 }
  default_scope { normal }
end
