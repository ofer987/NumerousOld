class Fichier < ActiveRecord::Base
  belongs_to :photo
  
  has_one :filesize_type, primary_key: :filesize_type_id, foreign_key: :id, readonly: true
  
  def filesize_type=(selected_filesize_type)
    self.filesize_type_id = selected_filesize_type.id
  end
  
  # get the filename
  def filename
    if (filesize_type.name == 'original')
      self.photo.filename
    else
      /^([^\.]+)\.(jpg|png)/i =~ self.photo.filename
      $1 + "_" + self.filesize_type.name + "." + $2
    end
  end
end
