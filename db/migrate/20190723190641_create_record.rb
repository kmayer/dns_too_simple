class CreateRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :name
      t.integer :ttl
      t.string :record_data
      t.string :type
      t.integer :zone_id, null: false
      t.timestamps
    end
  end
end
