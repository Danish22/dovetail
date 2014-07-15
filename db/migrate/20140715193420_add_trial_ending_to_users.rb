class AddTrialEndingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_ending, :datetime
  end
end
