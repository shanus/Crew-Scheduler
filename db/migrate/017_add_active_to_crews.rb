class AddActiveToCrews < ActiveRecord::Migration
  def self.up
    add_column :teams, :active, :boolean, :default => true
    teams = Team.find :all
    for team in teams
      team.active = true
      team.save
    end
  end

  def self.down
    add_column :teams, :active
  end
end
