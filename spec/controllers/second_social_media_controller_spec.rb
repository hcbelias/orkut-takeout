require 'rails_helper'

describe SecondSocialMediaController do
  let(:current_user_json) {
    %Q({
      "_id":"56df404693a9a845256d305b",
      "provider":"local",
      "name":"henriqueelias",
      "email":"hcbe2004@gmail.com",
      "password":"201286",
      "__v":0,
      "role":"user"
    })
  }

  let(:stubbed_sign_in_response) {
    stubbed_sign_in_response = double()
    allow(stubbed_sign_in_response).to receive(:body).and_return("my token")
    stubbed_sign_in_response
  }

  let(:friends_json){
    %Q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}])
  }

  let(:user_stubbed_response){
    user_stubbed_response = double()
    allow(user_stubbed_response).to receive(:body).and_return(current_user_json)
    user_stubbed_response
  }

  let(:friends_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_json)
    friends_stubbed_response
  }

  it "should throw an error if login parameters are not passed" do
    #exercise and verify
    expect{ get :export }.to raise_error(/User missing/)
  end

  it "should export my data to XML format when I enter my credentials" do
    #setup
    allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

    allow(RestClient::Request).to receive(:execute).with(hash_including(url:/friendships\/me/)).and_return(friends_stubbed_response)

    allow(RestClient::Request).to receive(:execute).with(hash_including(url:/users\/me/)).and_return(user_stubbed_response)

    #exercise
    get :export, user: "my_user@me", password: "my_password"

    data_return = Hash.from_xml(response.body)
    #verify
    expect(data_return["user"]).to_not be_nil
    expect(data_return["user"]["name"]).to eq "henriqueelias" # Checking current user info
    expect(data_return["user"]["email"]).to eq "hcbe2004@gmail.com" # Checking current user info
    expect(data_return["user"]["friends"]).to_not be_nil # Checking frined's current user
    expect(data_return["user"]["friends"]["friend"]).to_not be_nil# Checking frined's current user
    expect(data_return["user"]["friends"]["friend"].length).to eq 5# Checking frined's current user
  end
end
