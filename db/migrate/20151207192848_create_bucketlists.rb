class CreateBucketlists < ActiveRecord::Migration
  def change
    create_table :bucketlists do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true
      t.boolean :publicity, default: false

      t.timestamps null: false
    end
  end
end
