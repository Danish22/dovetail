class CreatePlanResources < ActiveRecord::Migration
  def change
    create_table :plan_resources do |t|
      t.references :plan, index: true
      t.references :resource, index: true

      t.timestamps
    end
  end
end
