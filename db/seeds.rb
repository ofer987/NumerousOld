# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Fichier.delete_all
Photo.delete_all
Phototag.delete_all

# Create photos

start_datetime = DateTime.civil(2011, 12, 29, 0, 0, 0)

for i in 0..99
  photo = Photo.new()
  photo.title = "Photo_#{i}"
  photo.description = "This is photo #{i}"
  photo.filename = 'img_3137.jpg'
  
  photo.taken_date = start_datetime.advance(minutes: i)
  
  # create an original file for this photo
  fichier = photo.fichiers.new()
  fichier.filesize_type = FilesizeType.find_by_name('original')
  
  # create a thumbnail for this photo 
  fichier = photo.fichiers.new()
  fichier.filesize_type = FilesizeType.find_by_name('thumbnail')
  
  photo.save  
end