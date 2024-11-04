require_dependency 'time_entry'
module TimeEntryPatch
  def self.included(base)
    base.class_eval do
      validate :validate_timelog_lock

      def validate_timelog_lock
        if spent_on && user
          if spent_on > user.today && !Setting.timelog_accept_future_dates?
            errors.add :base, I18n.t(:error_spent_on_future_date)
          elsif date_is_locked_for_user?
            errors.add :base, I18n.t(:error_spent_on_old_date, :days => Setting.plugin_timelog_lock['timelog_lock_days_older_than'].to_i)
          end
        end
      end

      def editable_by?(usr)
        visible?(usr) && !date_is_locked_for_user? && (
          (usr == user && usr.allowed_to?(:edit_own_time_entries, project)) || usr.allowed_to?(:edit_time_entries, project)
        )
      end

      def date_is_locked_for_user?
        return false unless user && spent_on

        number_of_days = Setting.plugin_timelog_lock['timelog_lock_days_older_than'].to_i
        (user.today - spent_on).to_i > number_of_days && !User.current.allowed_to?(:manage_time_entries_on_locked_dates, project)
      end
    end
  end
end

TimeEntry.include TimeEntryPatch