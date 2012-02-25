class Phototag < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #photo_id: integer, FKEY, NOT NULL
  #name: varchar(255)
  #created_at: datetime
  #updated_at: datetime
  
  belongs_to :photo
end