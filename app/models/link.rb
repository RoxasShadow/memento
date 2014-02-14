class Link < ActiveRecord::Base
  validates :title, :presence => true,
                    :length   => { minimum: 3 }

  validates :url,   :allow_blank => true,
                    :url         => true

  validates :feeds, :allow_blank => true,
                    :url         => true

  belongs_to :user

  default_scope { order 'priority ASC' }

  before_save do
    self.priority ||= self.id
  end
end
