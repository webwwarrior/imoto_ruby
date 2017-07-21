class AddFieldsAccessAndRefreshTokenToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :google_access_token, :string
    add_column :photographers, :google_refresh_token, :string
    add_column :photographers, :provider, :string
    add_column :photographers, :uid, :string
    add_column :photographers, :google_expires_at, :integer
  end
end
