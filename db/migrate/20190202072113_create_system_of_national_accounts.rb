class CreateSystemOfNationalAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :system_of_national_accounts do |t|
      t.string :date_code
      t.string :date_name
      t.string :category_code
      t.string :category_name
      t.integer :amount
      t.string :period_time
      
      t.timestamps
    end
  end
end
