class HelloController < ApplicationController
  def index
    @hello = Hello.all
  end

  def create
    @get = Hello.new(content:params[:content])
    @get.save
    redirect_to("/hello/index")
  end
end
