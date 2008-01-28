require File.dirname(__FILE__) + '/../test_helper'

class AccessoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:accessories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_accessory
    assert_difference('Accessory.count') do
      post :create, :accessory => { }
    end

    assert_redirected_to accessory_path(assigns(:accessory))
  end

  def test_should_show_accessory
    get :show, :id => accessories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => accessories(:one).id
    assert_response :success
  end

  def test_should_update_accessory
    put :update, :id => accessories(:one).id, :accessory => { }
    assert_redirected_to accessory_path(assigns(:accessory))
  end

  def test_should_destroy_accessory
    assert_difference('Accessory.count', -1) do
      delete :destroy, :id => accessories(:one).id
    end

    assert_redirected_to accessories_path
  end
end
