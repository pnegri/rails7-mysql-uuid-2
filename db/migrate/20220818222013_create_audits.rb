class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits, id: :binary, limit: 16 do |t|
      t.string :log

      t.timestamps
    end
  end
end
