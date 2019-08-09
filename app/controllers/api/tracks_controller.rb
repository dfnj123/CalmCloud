class Api::TracksController < ApplicationController

    def create
        @track = User.new(track_params)
        @track.user_id = current_user.id

        errs = ["placeholder error"];

        if @track.save
            login!(@track)
            render :show
        else
            render json: @user.errors.full_messages, status: 401
        end

        # Please choose an audio file (MP3, AAC, M4A, MP4 audio or OGG file types are supported) and make sure it is under 500MB.
        # Please enter a title below.
        # The file you've chosen is under 12MB - this indicates it may be short and, therefore, a single track and could be removed from Mixcloud.
    end

    def update
        @track = selected_track
        if @track && @track.update_attributes(track_params)
            render :show
        elsif !@track
            render json: ['Could not locate track'], status: 400
        else
            render json: @track.errors.full_messages, status: 401
        end
    end

    def index
        @tracks = Track.includes(:user)
    end

    def show
        @track = Track.includes(:user).find(params[:id])
    end

    def destroy
        @track = current_user.tracks.find(params[:id])
        if @track
            @track.destroy
        end
    end

    private

    def selected_track
        Track.find(params[:id])
    end

    def track_params
        params.require(:track).permit(:title, :audio_track, :description)
    end

end