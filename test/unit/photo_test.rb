require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test "photo attributes must not be empty" do
    photo = Photo.new
    assert photo.invalid?
    assert photo.errors[:filename].any?
  end
  
  test "photo current_order must be greater or equal to 1" do
    photo = photos(:in_front_of_tour_eiffel)
  
    photo.current_order = -1
    assert photo.invalid?
    assert_equal "must be greater than or equal to 1",
      photo.errors[:current_order].join('; ')
  
    photo.current_order = 0
    assert photo.invalid?
    assert_equal "must be greater than or equal to 1",
      photo.errors[:current_order].join('; ')

    photo.current_order = 1
    assert photo.valid?
  end
  
  test "thumbnail" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
              http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert get_photo_thumbnail(name).valid?, "#{name} shouldn't be invalid"
    end
  
    bad.each do |name|
      assert get_photo_thumbnail(name).invalid?, "#{name} shouldn't be valid"
    end 
  end
  
  test "filename" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
              http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert get_photo(name).valid?, "#{name} shouldn't be invalid"
    end
  
    bad.each do |name|
      assert get_photo(name).invalid?, "#{name} shouldn't be valid"
    end 
  end
  
  test "upload new photo" do
    games_photo = Photo.new()
    games_photo.title = 'Games Photo'
    games_photo.descrption = 'description 01'
    
    games_photo.photo_data = File.read('photo_store/games.jpg')
    games_photo.filename = 'games.jpg'
    
    assert games.save, "the #{games_photo.title} photo should have saved properly"
  end
  
  test "Save two photos with same name" do
    # first file
    games_photo = Photo.new()
    games_photo.title = 'Games Photo'
    games_photo.descrption = 'description 01'
    games_photo.photo_data = File.read('photo_store/games.jpg')
    games_photo.filename = set_filename('games.jpg')
    
    assert games.save, "the first #{games_photo.title} photo should have saved properly"
    
    # second file
    photo_with_same_name = Photo.new()
    photo_with_same_name.set_filename(games_photo.filename)
    
    assert photo_with_same_name.filename != games_photo.filename
  end
  
  def get_photo(filename)
    # return some test photo fixture
    photo = photos(:eaton_college)
    photo.filename = filename
    
    return photo
  end
end
