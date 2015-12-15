class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :details
      t.references :bucketlist, index: true, foreign_key: true
      t.boolean :done, default: false

      t.timestamps null: false
    end
  end
end
