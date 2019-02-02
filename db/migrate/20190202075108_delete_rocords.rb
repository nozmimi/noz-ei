class DeleteRocords < ActiveRecord::Migration[5.2]
  def change
    drop_table :system_of_national_accounts
  end
end
