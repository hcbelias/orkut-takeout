require 'rails_helper'

describe SignInController do
  it "should redirect to first social media when selected" do
    get :export, :export => 'social_network_1'
    response.should redirect_to('/first-social-media/export?action=export&controller=sign_in&export=social_network_1')
  end
  it "should redirect to second social media when selected" do
    get :export, :export => 'social_network_2'
    response.should redirect_to('/second-social-media/export?action=export&controller=sign_in&export=social_network_2')
  end
  it "should redirect to third social media when selected" do
    get :export, :export => 'social_network_3'
    response.should redirect_to('/third-social-media/export?action=export&controller=sign_in&export=social_network_3')
  end
  it "should throw an exception if an invalid parameter is selected" do
    expect{ get :export, :export => 'not_valid_value' }.to raise_error(/RecordNotFound/)
  end
end
