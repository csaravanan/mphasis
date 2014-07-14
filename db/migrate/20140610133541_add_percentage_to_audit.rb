class AddPercentageToAudit < ActiveRecord::Migration
  def change
    add_column :audits, :percentage, :float, :precision => 8,:scale => 2
  end
end
