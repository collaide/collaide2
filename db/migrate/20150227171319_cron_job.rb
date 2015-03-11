class CronJob < ActiveRecord::Migration
  def change
    create_table :cron_jobs do |t|
      t.string :job_name
      t.datetime :start_at

      t.timestamps
    end
  end
end
