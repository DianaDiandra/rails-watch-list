class ReviewsController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    @review = Review.new(review_params)
    if @review.save
      redirect_to list_path(@list), notice: "Review added!"
    else
      render "lists.show", status: :unprocessable_entity
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to list_path(@review.list), notice: "Review removed"
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
