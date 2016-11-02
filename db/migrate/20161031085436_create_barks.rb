class CreateBarks < ActiveRecord::Migration
  def change
    create_table :barks do |t|
      t.string :value
    end
  end
end
