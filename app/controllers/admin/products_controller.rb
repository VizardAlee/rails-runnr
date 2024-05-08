class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  # GET /admin/products or /admin/products.json
  def index
    if params[:query].present?
      @pagy, @admin_products = pagy(Product.where("name LIKE ?", "%#{params[:query]}%"))
    else
      @pagy, @admin_products = pagy(Product.all)
    end
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show
    @product = Product.find(params[:id]) 
    @product_stock = @product.product_stocks.find_by(id: params[:id]) # Use find_by

    if @product_stock
      # Render the show page 
    else
      redirect_to admin_product_product_stocks_path(@product), notice: "Product stock not found."
    end
  end
  
  # GET /admin/products/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products or /admin/products.json
  def create
    @admin_product = Product.new(admin_product_params) 
  
    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_product_stocks_path(@admin_product), notice: "Product was successfully created." } 
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end 

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  def update
    @admin_product = Product.find(params[:id])
    if @admin_product.update(admin_product_params.reject { |k| k['images']})
      if admin_product_params['images']
        admin_product_params['images'].each do |image|
          begin
            @admin_product.images.attach(image)
          rescue Aws::S3::Errors::Base => e
            # Log the error details
            Rails.logger.error "S3 Upload Error: #{e.message}"
            # Display a user-friendly error message
            flash[:alert] = "Image upload failed. Please check your S3 configuration."
          end
        end
        redirect_to admin_products_path, notice: "Product updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end  

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.product_stocks.destroy_all
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product
      @admin_product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
    end
end
