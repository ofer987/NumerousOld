class Photo < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #title: varchar(255), NOT NULL
  #description: text, NOT NULL
  #thumbnail: varchar(255), NOT NULL
  #filename: varchar(255), NOT NULL
  #taken_date: datetime, NOT NULL, DEFAULT: DateTime.current
  #created_at: datetime
  #updated_at: datetime
  
  has_many :photo_tags
  has_many :fichiers, dependent: :destroy
  
  # need to validate title and description
  validates :taken_date, presence: true
  #validates :current_order, numericality: {greater_than_or_equal_to: 1}
  #validates :current_order, uniqueness: { :scope => :album_id } 
  #validates :thumbnail, :filename, allow_blank: true, format: {
  #  with: %r{\.(jpg|png)$}i,
  #  message: 'File must be either JPEG or PNG.'
  #}
  
  # Root directory of the photo public/photos
  PHOTO_STORE = Rails.root.join('app', 'assets', 'images')
  
  # Invoke save_photo method when save is completed
  before_save :before_save
  after_save  :after_save
 
  def get_fichier(filesize_type)
    for fichier in self.fichiers do
			if fichier.filesize_type == filesize_type then
				selected_fichier = fichier
				break
			end
		end
		
		return selected_fichier
	end
 
  # "f.file_field :load_photo_file" in the view triggers Rails to invoke this method
  # This method only store the information
  # The file saving is done in before_save
  def load_photo_file=(data)
    # Store the data for later use
    set_filename(data.original_filename)
    @photo_data = data
  end
  
  def before_save   
    if @photo_data
      # Write the data out to a file
      original_filename = File.join(PHOTO_STORE, self.filename)      
      if (@photo_data != nil)
        File.open(original_filename, 'wb') do |f|
          f.write(@photo_data.read)
        end
      end
            
      # Load the image
      @saved_image = ImageList.new(original_filename) 
    
      # Store the date the image as taken
      image_datetime = @saved_image.get_exif_by_entry('DateTimeOriginal')[0][1]
      self.taken_date = DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S')
    end
  end
  
  def after_save
    if @photo_data
      # Create the files
      create_and_resize_fichiers
            
      @photo_date = nil
    end
  end
  
  def set_filename(new_filename)
    # If another photo already uses the same file,
    # then add a number to the end of the filename untill unique
    i = 0
    while true
      existing_filename = File.join(PHOTO_STORE, new_filename)
      if File.exists?(existing_filename)
        i++
        /^([^\.]+)\.(jpg|png)/i =~ new_filename
        new_filename = $1 + "_" + i.to_s + "." + $2 
      else
        break
      end
    end
    
    self.filename = new_filename
  end
  
  private
  
  def create_and_resize_fichiers
    for filesize_type in FilesizeType.all do
      if (filesize_type.width < @saved_image.columns or
        filesize_type.height < @saved_image.rows) then
        resized_image = @saved_image.resize_to_fit(fichier.filesize_type.width, fichier.filesize_type.height)
      
        fichier = self.fichiers.new()
        fichier.filesize_type = filesize_type
      
        # get the filename
        resized_image_filename = File.join(PHOTO_STORE, fichier.filename)
        
        # write the file
        resized_image.write(resized_image_filename)
      elsif (filesize_type.name == 'original')
        # Just create a fichier record in the db
        # no need to save the file to hdd because the original file has
        # already been saved
        fichier = self.fichiers.new()
        fichier.filesize_type = filesize_type
      end
    end
  end
end