class CreateUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_relations do |t|
      t.integer :user_id,   null: false, default: 0, comment: '当前用户ID'
      t.integer :friend_id, null: false, default: 0, comment: '当前用户ID'
      t.integer :status,    null: false, default: 0, comment: '好友状态, 0 好友 1 已删除'

      t.timestamps
    end

    add_index :user_relations, [:user_id, :status]
  end
end
