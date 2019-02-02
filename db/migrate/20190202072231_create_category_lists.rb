class CreateCategoryLists < ActiveRecord::Migration[5.2]
  def change
    create_table :category_lists do |t|
      t.string :category_code
      t.string :category_name
      t.time :data_update_date

      t.timestamps
    end
  end
end
