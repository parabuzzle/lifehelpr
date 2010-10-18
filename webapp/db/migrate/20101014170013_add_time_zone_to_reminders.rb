class AddTimeZoneToReminders < ActiveRecord::Migration
    def self.up
      add_column "default_reminder_schedules", "time_zone", :string, :default => "Pacific Time (US & Canada)"
      add_column "reminder_schedules", "time_zone", :string, :default => "Pacific Time (US & Canada)"
    end

    def self.down
      remove_column "default_reminder_schedules", "time_zone"
      remove_column "reminder_schedules", "time_zone"
    end
  end