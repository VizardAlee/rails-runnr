require "application_system_test_case"

class Admin::ProductStocksTest < ApplicationSystemTestCase
  setup do
    @admin_product_stock = admin_product_stocks(:one)
  end

  test "visiting the index" do
    visit admin_product_stocks_url
    assert_selector "h1", text: "Product stocks"
  end

  test "should create product stock" do
    visit admin_product_stocks_url
    click_on "New product stock"

    fill_in "Product", with: @admin_product_stock.product_id
    fill_in "Quantity", with: @admin_product_stock.quantity
    fill_in "Size", with: @admin_product_stock.size
    click_on "Create Product stock"

    assert_text "Product stock was successfully created"
    click_on "Back"
  end

  test "should update Product stock" do
    visit admin_product_stock_url(@admin_product_stock)
    click_on "Edit this product stock", match: :first

    fill_in "Product", with: @admin_product_stock.product_id
    fill_in "Quantity", with: @admin_product_stock.quantity
    fill_in "Size", with: @admin_product_stock.size
    click_on "Update Product stock"

    assert_text "Product stock was successfully updated"
    click_on "Back"
  end

  test "should destroy Product stock" do
    visit admin_product_stock_url(@admin_product_stock)
    click_on "Destroy this product stock", match: :first

    assert_text "Product stock was successfully destroyed"
  end
end
