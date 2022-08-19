class CreateAuditLines < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_lines, id: :binary, limit: 16 do |t|
      t.references :audit, null: false, foreign_key: true, type: :binary, limit: 16
      t.string :log

      t.timestamps
    end
  end
end
