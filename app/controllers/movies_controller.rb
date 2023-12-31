class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # CHECK IF BLANK AND BEHAVE NORMALLY


    if session[:sort_column] || session[:ratings]
      @all_ratings = Movie.all_ratings
      @sort_column = session[:sort_column] || ""
      @params_column = params[:sortColumn] || ""
      if session[:ratings].class == Hash
        if session[:ratings] == params[:ratings]
          if session[:sort_column] == @params_column
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@sort_column)
            @ratings_to_show = params[:ratings].keys()
          elsif !params[:sortColumn].blank? 
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@params_column)
            @ratings_to_show = params[:ratings].keys()
            session[:sort_column] = @params_column
            @sort_column = @params_column
          else
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@sort_column)
            @ratings_to_show = session[:ratings].keys()
            params[:sortColumn] = session[:sort_column]
          end
        elsif !params[:ratings].blank?
          if session[:sort_column] == @params_column
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@sort_column)
            @ratings_to_show = params[:ratings].keys()
          elsif !params[:sortColumn].blank? 
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@params_column)
            @ratings_to_show = params[:ratings].keys()
            session[:sort_column] = @params_column
            @sort_column = @params_column
          else
            @movies = Movie.with_ratings(session[:ratings].keys()).order(@sort_column)
            @ratings_to_show = session[:ratings].keys()
            params[:sortColumn] = session[:sort_column]
          end
          @movies = Movie.with_ratings(params[:ratings].keys()).order(@sort_column)
          @ratings_to_show = params[:ratings].keys()
          session[:ratings] = params[:ratings]
        else
          @movies = Movie.with_ratings(session[:ratings].keys()).order(@sort_column)
          @ratings_to_show = session[:ratings].keys()
          params[:ratings] = session[:ratings]
          params[:home] = 1
          redirect_to movies_path('sortColumn': session[:sort_column], 'ratings': session[:ratings], home: params["home"])
        end
      else
        @all_ratings = Movie.all_ratings
        @ratings_to_show = []
        @sort_column = params[:sortColumn] || ""
        if params[:ratings]
          @ratings_to_show = params[:ratings].keys()
          session[:ratings] = params[:ratings]
          session[:sort_column] = @sort_column
          @movies = Movie.with_ratings(params[:ratings].keys()).order(@sort_column)
        else
          @ratings_to_show = Movie.all_ratings
          session[:ratings] = []
          session[:sort_column] = @sort_column
          @movies = Movie.with_ratings(nil).order(@sort_column)
        end
  
        if params[:ratings].blank?
          params[:ratings] = Movie.all_ratings
        end
      end
    else
      @all_ratings = Movie.all_ratings
      @ratings_to_show = []
      @sort_column = params[:sortColumn] || ""
      if params[:ratings]
        @ratings_to_show = params[:ratings].keys()
        session[:ratings] = params[:ratings]
        session[:sort_column] = @sort_column
        @movies = Movie.with_ratings(params[:ratings].keys()).order(@sort_column)
      else
        @ratings_to_show = Movie.all_ratings
        session[:ratings] = []
        session[:sort_column] = @sort_column
        @movies = Movie.with_ratings(nil).order(@sort_column)
      end

      if params[:ratings].blank?
        params[:ratings] = Movie.all_ratings
      end

      
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
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sortColumn, :home)
  end
end
