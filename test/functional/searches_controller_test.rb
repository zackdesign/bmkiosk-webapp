require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:search)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_search
    assert_difference('Search.count') do
      post :create, :search => { }
    end

    assert_redirected_to search_path(assigns(:search))
  end

  def test_should_show_search
    get :show, :id => search(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => search(:one).id
    assert_response :success
  end

  def test_should_update_search
    put :update, :id => search(:one).id, :search => { }
    assert_redirected_to search_path(assigns(:search))
  end

  def test_should_destroy_search
    assert_difference('Search.count', -1) do
      delete :destroy, :id => search(:one).id
    end

    assert_redirected_to search_path
  end
end
