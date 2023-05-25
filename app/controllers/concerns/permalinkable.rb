module Permalinkable
  extend ActiveSupport::Concern

  included do
    before_create :add_permalink
  end

  private

    def add_permalink
      loop do
        self.permalink = SecureRandom.urlsafe_base64
        break unless self.class.exists?(permalink: self.permalink)
      end
    end
end
