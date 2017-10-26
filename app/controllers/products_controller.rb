class ProductsController < ApplicationController
  before_action :find_product , only: [:show, :edit, :update]
  def root
    @top_products =  Product.select("products.id, avg(reviews.rating) as average_rating").where(active: true).joins("LEFT JOIN reviews ON products.id = reviews.product_id").group("products.id").order("average_rating DESC NULLS LAST").limit(8)
    #Product.joins("LEFT JOIN order_products ON products.id = order_products.product_id").group(:id).order("count(order_products.id)  DESC").limit(10)
    @recent_products =  Product.where(active: true).order(created_at: :desc).limit(8)
  end

  def index
    @categories = Category.order(:name)

    if params[:category_id]
      if Category.find_by(id: params[:category_id]) == nil
        render_404
      else
        @products = Product.includes(:categories).where(active: true, categories: { id: params[:category_id]})
      end
    elsif params[:user_id]
      if User.find_by(id: params[:user_id]) == nil
        render_404
      else
        @products = Product.includes(:user).where(active: true, products: {user_id: params[:user_id]})
      end
    elsif params[:search]
        @products = Product.search(params[:search]).order(:name)
    else
      @products = Product.where(active: true).order(:id)
    end
  end

  def show
    @order_product = OrderProduct.new
  end

  def new
    if find_user
      @product = Product.new
    else
      flash[:status] = :failure
      flash[:result_text] = "Oops..You need to be logged in to add a product!"
      redirect_to products_path
    end
  end

  def create
    if find_user
      @product = Product.new(product_params)
      #appends categories into @products.categories
      temp = @product.categories.map {|c| c.id }
      if params[:product][:category_ids]
        params[:product][:category_ids].each do |category|
          if !temp.include?(category) && category != ""
            @product.categories << Category.find(category)
          end
        end
      end

      #replaces empty string with default image
      if params[:product][:image] == ""
        @product.image = valid_image
      end

      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created #{@product.name}!"
        redirect_to product_path(@product)
      else
        flash.now[:status] = :error
        flash.now[:result_text] = "#{@product.name} could not be created"
        render :new, status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Oops..You can't create a product for someone else!"
      redirect_to products_path
    end
  end

  def edit
    if find_user
      if @user.id != @product.user.id
        flash[:status] = :failure
        flash[:result_text] = "Oops..This isn't your product!"
        redirect_to product_path(@product.id)
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Oops..You're not logged in!"
      redirect_to product_path(@product.id)
    end
  end

  def update
    if find_user && (@user.id != @product.user.id)
      flash[:status] = :failure
      flash[:result_text] = "Oops..This isn't your product!"
      redirect_to product_path(@product.id)
    else
      # note: clears categories, will keep categories if categories is not updated
      @product.categories = []
      #appends categories into @products.categories
      if params[:product][:category_ids]
        params[:product][:category_ids].each do |category|
          unless category == ""
            @product.categories << Category.find(category)
          end
        end
      end
      @product.update_attributes(product_params)
      #replaces empty string with default image
      if @product.image.length == 0
        @product.image = valid_image
      end

      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated #{@product.name}!"
        redirect_to product_path
      else
        flash.now[:status] = :error
        flash.now[:result_text] = "#{@product.name} could not be updated"
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
  end

  def toggle_active
    @product = Product.find_by(id: params[:id])
    # @product.active = params[:product][:active].to_i
    if @product.active
      @product.active = false
    else
      @product.active = true
    end

    if @product.save
      redirect_to user_path(@product.user)
    end
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

  def product_params
    return params.require(:product).permit(:user_id, :name, :price, :stock, :description, :image, :active)
  end

  def render_404
    render file: "/public/404.html", status: 404
  end

  def valid_image
    "http://placebeyonce.com/200-300"
  end
end
