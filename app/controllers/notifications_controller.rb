class NotificationsController < ApplicationController
  def index
    @persona = ensure_persona!
    FakeNotifier.backfill!(@persona)
    @notifications = @persona.notifications.recent.includes(:actor)
    @persona.notifications.unread.update_all(read: true)
  end
end
