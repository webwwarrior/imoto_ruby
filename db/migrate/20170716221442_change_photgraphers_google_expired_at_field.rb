class ChangePhotgraphersGoogleExpiredAtField < ActiveRecord::Migration[5.0]
  def change
    change_column :photographers, :google_expires_at, :integer, limit: 8
  end
end
