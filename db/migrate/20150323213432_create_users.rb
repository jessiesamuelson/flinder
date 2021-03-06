class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name, null: false
    	t.string :email, null: false
    	t.string :password_digest, null: false
    	t.string :region
    	t.string :session_token
      t.string :oauth_token 
      t.string :oauth_secret
       
      t.timestamps null: false
    end
  end
end