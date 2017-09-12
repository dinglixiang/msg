class CreateUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_relations do |t|
      t.integer :user_id,   null: false, default: 0, comment: '用户ID'
      t.integer :friend_id, null: false, default: 0, comment: '联系人ID'
      t.integer :status,    null: false, default: 0, limit: 1, comment: '好友状态, 0 好友 1 已删除'

      t.timestamps
    end

    add_index :user_relations, [:user_id, :status, :friend_id]
  end
end
