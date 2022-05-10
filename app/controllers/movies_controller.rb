class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sorting_rule] != nil 
      @sorting_rule = params[:sorting_rule]
    else
      @sorting_rule = session[:sorting_rule]
    end

    @all_ratings = Movie.get_all_ratings
    @ratings =  params[:ratings] || session[:ratings] || Hash[@all_ratings.map {|rating| [rating, rating]}]

    @movies = Movie.where(rating:@ratings.keys).order(@sorting_rule)

    # save current config in session
    if params[:sorting_rule] != session[:sorting_rule] or params[:ratings] != session[:ratings]
      session[:ratings] = @ratings
      session[:sorting_rule] = @sorting_rule
      flash.keep
      redirect_to movies_path(sorting_rule: session[:sorting_rule], ratings: session[:ratings])
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
