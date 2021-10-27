class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :email_id
      t.string :role, :limit => 20
      t.string :otp
      t.datetime :otp_expired

      t.timestamps
    end
  end
end
