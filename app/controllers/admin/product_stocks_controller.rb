class Admin::ProductStocksController < AdminController
  before_action :set_admin_product_stock, only: %i[ show edit update destroy ]

  # GET /admin/product_stocks or /admin/product_stocks.json
  def index
    @product = Product.find(params[:product_id])
    @product_stocks = @product.product_stocks
  end

  # GET /admin/product_stocks/1 or /admin/product_stocks/1.json
  def show
  end

  # GET /admin/product_stocks/new
  def new
    @product = Product.find(params[:product_id])
    @product_stock = @product.product_stocks.new
  end

  # GET /admin/product_stocks/1/edit
  def edit 
    @product = Product.find(params[:product_id])
    @admin_product_stock = ProductStock.find(params[:id])
  end

  # POST /admin/product_stocks or /admin/product_stocks.json
  def create
    @product = Product.find(params[:product_id]) 
    @admin_product_stock = @product.product_stocks.build(admin_product_stock_params)
  
    respond_to do |format|
      if @admin_product_stock.save
        format.html { redirect_to admin_product_product_stocks_path(@product), notice: "Product stock was successfully created." }
        format.json { render :show, status: :created, location: @admin_product_stock } 
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product_stock.errors, status: :unprocessable_entity }
      end
    end
  end 
  

  # PATCH/PUT /admin/product_stocks/1 or /admin/product_stocks/1.json
  def update
    respond_to do |format|
      if @admin_product_stock.update(admin_product_stock_params)
        format.html { redirect_to admin_product_product_stock_url(@admin_product_stock), notice: "Product stock was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_product_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_product_product_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_stocks/1 or /admin/product_stocks/1.json
  def destroy
    @admin_product_stock.destroy!

    respond_to do |format|
      format.html { redirect_to admin_product_product_stocks_url, notice: "Product stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product_stock
      @admin_product_stock = ProductStock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_product_stock_params
      params.require(:product_stock).permit(:size, :quantity)
    end
end
