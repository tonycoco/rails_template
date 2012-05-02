class UserWorker
  @queue = :normal

  class << self
    def perform(method, *args)
      self.send(method, *args)
    end

    def save_avatar(options={})
      user = User.find(options['user_id'])
      if user.data.try(:[], :facebook).present?
        user.remote_avatar_url = user.data[:facebook].info.image
        user.save!
      end
    end
  end
end
