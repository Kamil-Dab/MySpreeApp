class CreatePromotions < ActiveRecord::Migration[6.1]
  def change
    create_table :promotions do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :conditions, null: false, default: {}

      t.timestamps
    end
  end
end
