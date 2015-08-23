require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quote" do
    assert_difference('Quote.count') do
      post :create, quote: { bathrooms: @quote.bathrooms, bedrooms: @quote.bedrooms, cleaning_supplies: @quote.cleaning_supplies, day_preference: @quote.day_preference, eco_friendly: @quote.eco_friendly, laundry: @quote.laundry, location: @quote.location, name: @quote.name, oven: @quote.oven, pets: @quote.pets, quote_type: @quote.quote_type, recurrence: @quote.recurrence, refrigerator: @quote.refrigerator, request_time: @quote.request_time, square_feet: @quote.square_feet, time_preference: @quote.time_preference, type_of_home: @quote.type_of_home, windows: @quote.windows }
    end

    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should show quote" do
    get :show, id: @quote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quote
    assert_response :success
  end

  test "should update quote" do
    patch :update, id: @quote, quote: { bathrooms: @quote.bathrooms, bedrooms: @quote.bedrooms, cleaning_supplies: @quote.cleaning_supplies, day_preference: @quote.day_preference, eco_friendly: @quote.eco_friendly, laundry: @quote.laundry, location: @quote.location, name: @quote.name, oven: @quote.oven, pets: @quote.pets, quote_type: @quote.quote_type, recurrence: @quote.recurrence, refrigerator: @quote.refrigerator, request_time: @quote.request_time, square_feet: @quote.square_feet, time_preference: @quote.time_preference, type_of_home: @quote.type_of_home, windows: @quote.windows }
    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should destroy quote" do
    assert_difference('Quote.count', -1) do
      delete :destroy, id: @quote
    end

    assert_redirected_to quotes_path
  end
end
