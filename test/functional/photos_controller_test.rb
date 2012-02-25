require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @album = albums(:latin_america)
    @photo = photos(:machu_pichu) # this photo belongs to the album latin_america, this is important be
                                  # because we later want to one of its photos with
                                  # update machu_pichu_photo_update
    @machu_pichu_photo_update = {
      album_id: @album.id,
      title: 'Lorem Ipsum Photo',
      description: 'Description for Lorem Ipsum',
      thumbnail: 'rails.png',
      filename: 'IMG_3137.jpg',
      current_order: 999999 # pick a unique large number that is most likely not already taken 
    }
  end

  test "should get index" do
    get :index, album_id: @album.id
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  test "should get new" do
    get :new, album_id: @album.id
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, album_id: @album.id, photo: @machu_pichu_photo_update
    end

    assert_redirected_to album_photo_path(assigns(:album), assigns(:photo))
  end

  test "should show photo" do
    get :show, album_id: @album.id, id: @photo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, album_id: @album.id, id: @photo.to_param
    assert_response :success
  end

  test "should update photo" do
    put :update, album_id: @album.id ,id: @photo.to_param, photo: @machu_pichu_photo_update
    assert_redirected_to album_photo_path(assigns(:album), assigns(:photo))
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete :destroy, album_id: @album.id, id: @photo.to_param
    end

    assert_redirected_to album_photos_path(assigns(:album))
  end
end
