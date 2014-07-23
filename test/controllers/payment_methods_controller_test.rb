require 'test_helper'

class PaymentMethodsControllerTest < ActionController::TestCase
  setup do
    @payment_method = payment_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment_method" do
    assert_difference('PaymentMethod.count') do
      post :create, payment_method: { billing_email: @payment_method.billing_email, billing_name: @payment_method.billing_name, company_nameL: @payment_method.company_nameL, stripe_id: @payment_method.stripe_id, user_id: @payment_method.user_id }
    end

    assert_redirected_to payment_method_path(assigns(:payment_method))
  end

  test "should show payment_method" do
    get :show, id: @payment_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment_method
    assert_response :success
  end

  test "should update payment_method" do
    patch :update, id: @payment_method, payment_method: { billing_email: @payment_method.billing_email, billing_name: @payment_method.billing_name, company_nameL: @payment_method.company_nameL, stripe_id: @payment_method.stripe_id, user_id: @payment_method.user_id }
    assert_redirected_to payment_method_path(assigns(:payment_method))
  end

  test "should destroy payment_method" do
    assert_difference('PaymentMethod.count', -1) do
      delete :destroy, id: @payment_method
    end

    assert_redirected_to payment_methods_path
  end
end
