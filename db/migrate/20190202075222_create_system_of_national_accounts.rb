class CreateSystemOfNationalAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :system_of_national_accounts do |t|
      t.string :category_code
      t.string :category_name
      t.string :date_code
      t.string :date_name
      t.integer :amount
      t.string :unit
      t.string :period_time
      t.string :update_date

      t.timestamps
    end
  end
end
