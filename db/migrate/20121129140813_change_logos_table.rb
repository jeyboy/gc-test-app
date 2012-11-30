class ChangeLogosTable < ActiveRecord::Migration
  def up
    rename_column :logos, :agency_id, :imageable_id
    add_column :logos, :imageable_type, :string
  end

  def down
    rename_column :logos, :imageable_id, :agency_id
    remove_column :logos, :imageable_type
  end
end
