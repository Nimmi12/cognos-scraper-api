require 'test_helper'

class IbmInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ibm_info = ibm_infos(:one)
  end

  test "should get index" do
    get ibm_infos_url, as: :json
    assert_response :success
  end

  test "should create ibm_info" do
    assert_difference('IbmInfo.count') do
      post ibm_infos_url, params: { ibm_info: { IBMid: @ibm_info.IBMid, password: @ibm_info.password, report_name: @ibm_info.report_name, report_xml: @ibm_info.report_xml } }, as: :json
    end

    assert_response 201
  end

  test "should show ibm_info" do
    get ibm_info_url(@ibm_info), as: :json
    assert_response :success
  end

  test "should update ibm_info" do
    patch ibm_info_url(@ibm_info), params: { ibm_info: { IBMid: @ibm_info.IBMid, password: @ibm_info.password, report_name: @ibm_info.report_name, report_xml: @ibm_info.report_xml } }, as: :json
    assert_response 200
  end

  test "should destroy ibm_info" do
    assert_difference('IbmInfo.count', -1) do
      delete ibm_info_url(@ibm_info), as: :json
    end

    assert_response 204
  end
end
