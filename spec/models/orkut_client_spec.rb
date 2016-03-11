require 'rails_helper'

describe OrkutClient do
  let(:orkut_client) { OrkutClient.new }

  let(:sign_in_response){
    sign_in_response = double()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
  }


  let(:friends_json){
    %Q([{"__v":0,"vipUserRequester":false,"vipUserRequested":false,"blockUserRequester":false,"blockUserRequested":false,"status":1},{"__v":0,"vipUserRequester":false,"vipUserRequested":false,"blockUserRequester":false,"blockUserRequested":false,"status":2},{"__v":0,"vipUserRequester":false,"vipUserRequested":false,"blockUserRequester":false,"blockUserRequested":false,"status":0}])
  }

  let(:friends_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_json)
    friends_stubbed_response
  }


  it "should signin to orkut server" do
    #setup
    expect(RestClient).to receive(:post)
        .with(/login/,
          hash_including(
            username: "pedrohrs08@gmail.com",
            password: "081289"
          )
        ).and_return(sign_in_response)

    #exercise
    orkut_client.sign_in("pedrohrs08@gmail.com","081289")
    #verify
    expect(Authorizable).to be_signed_in
  end

  it "should sign out from orkut server" do
    #setup
    expect(RestClient).to receive(:post).and_return(sign_in_response)
    orkut_client.sign_in("pedrohrs08@gmail.com","081289")
    #exercise
    orkut_client.sign_out
    #verify
    expect(Authorizable).to_not be_signed_in
  end



  it "should not perform login with invalid credentials" do
    #exercise and verify
    expect { orkut_client.sign_in("invalid@invalid.com","invalid") }.to raise_error(Exception)
  end

  it "should not get the friends info with invalid credentials" do
    #setup
    Authorizable.clear_token
    #exercise and verify
    expect { orkut_client.get_my_friends }.to raise_error(Exception)
  end


  it "should get the friends info with valid credentials" do
    #setup
    expect(RestClient).to receive(:post)
        .with(/login/,
          hash_including(
            username: "pedrohrs08@gmail.com",
            password: "081289"
          )
        ).and_return(sign_in_response)
    orkut_client.sign_in("pedrohrs08@gmail.com","081289")
    allow(RestClient::Request).to receive(:execute).with(hash_including(url:/friendships\/me/)).and_return(friends_stubbed_response)
    #exercise
    friend_list = orkut_client.get_my_friends
    #verify
    expect(friend_list.length).to eq 3
  end



end
