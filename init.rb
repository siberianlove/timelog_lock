require_relative 'lib/time_entry_patch'

Redmine::Plugin.register :timelog_lock do
  name 'Timelog Lock plugin'
  author ''
  description 'This is a plugin for locking time logs older than a configured number of days. Based on https://www.redmine.org/issues/13244#note-46'
  version '0.0.1'
  settings default: {'timelog_lock_days_older_than' => '9999'}, partial: 'settings/timelog_lock'

  project_module :time_tracking do
    permission :manage_time_entries_on_locked_dates, {}
  end
end