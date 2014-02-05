class Link < ActiveRecord::Base
  validates :title, :presence => true,
                    :length   => { minimum: 5 }

  validates :url,   :allow_blank => true,
                    :url         => true

  validates :feeds, :allow_blank => true,
                    :url         => true

  belongs_to :user
end
