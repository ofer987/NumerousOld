class PhotosController < ApplicationController
  before_filter :init_variables
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all(order: 'taken_date ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])
    @current_photo_index = Photo.all(order: 'taken_date ASC').rindex(@photo)
    
    @is_first_photo = @current_photo_index == 0
    @is_last_photo = @current_photo_index == Photo.all.count - 1
    
    @displayed_fichier = @photo.get_fichier(FilesizeType.find_by_name('small'))
    if @displayed_fichier == nil
      @displayed_fichier = @photo.get_fichier(FilesizeType.find_by_name('original'))
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])
    #@photo.title = 'hello'
    #@photo.description = 'mon cher ami'
    #@photo.filename = 'kaka.jpg'
    #@photo.thumbnail = 'thumb.jpg'
    #@photo.taken_date = DateTime.current
    
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photo_url(@photo), notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to photo_url(@photo), notice: 'Photo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :ok }
    end
  end
    
  private
    
  def init_variables
  end
end
