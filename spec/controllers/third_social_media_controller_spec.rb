require 'rails_helper'

describe ThirdSocialMediaController do
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


  let(:friends_15_json){
    friends_array = []

    15.times do
         friends_array << %Q({
                           "_id": "56ab7fc22e481306042c151d",
                            "user": {
                             "_id": "56ab7ee72e481306042c1518",
                             "name": "QA Couse User 1",
                             "email": "qacourseuser1@avenuecode.com"
                            }
                          })
    end
    friends_string = friends_array.join(",")

    "[#{friends_string}]"
  }


  let(:friends_13_json){
    friends_array = []

    13.times do
      friends_array << %Q({
                            "_id": "56ab7fc22e481306042c151d",
                            "user": {
                              "_id": "56ab7ee72e481306042c1518",
                              "name": "QA Couse User 1",
                              "email": "qacourseuser1@avenuecode.com"
                            }
                          })
    end
    friends_string = friends_array.join(",")

    "[#{friends_string}]"
  }

  let(:friends_12_json){
   friends_array = []

   12.times do
        friends_array << %Q({
                          "_id": "56ab7fc22e481306042c151d",
                           "user": {
                            "_id": "56ab7ee72e481306042c1518",
                            "name": "QA Couse User 1",
                            "email": "qacourseuser1@avenuecode.com"
                           }
                         })
   end
   friends_string = friends_array.join(",")

   "[#{friends_string}]"
  }

  let(:friends_10_json){
    friends_array = []

    10.times do
         friends_array << %Q({
                           "_id": "56ab7fc22e481306042c151d",
                            "user": {
                             "_id": "56ab7ee72e481306042c1518",
                             "name": "QA Couse User 1",
                             "email": "qacourseuser1@avenuecode.com"
                            }
                          })
    end
    friends_string = friends_array.join(",")

    "[#{friends_string}]"
  }

  let(:friends_2_json){
    friends_array = []

    2.times do
         friends_array << %Q({
                           "_id": "56ab7fc22e481306042c151d",
                            "user": {
                             "_id": "56ab7ee72e481306042c1518",
                             "name": "QA Couse User 1",
                             "email": "qacourseuser1@avenuecode.com"
                            }
                          })
    end
    friends_string = friends_array.join(",")

    "[#{friends_string}]"
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

  let(:friends_15_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_15_json)
    friends_stubbed_response
  }

  let(:friends_13_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_13_json)
    friends_stubbed_response
  }

  let(:friends_12_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_12_json)
    friends_stubbed_response
  }

  let(:friends_10_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_10_json)
    friends_stubbed_response
  }

  let(:friends_2_stubbed_response){
    friends_stubbed_response = double()
    allow(friends_stubbed_response).to receive(:body).and_return(friends_2_json)
    friends_stubbed_response
  }

  it "should throw an error if login parameters are not passed" do
    #exercise and verify
    expect{ get :export }.to raise_error(/User missing/)
  end

  context "When I export my friends list to Social Network 3" do
    it "should see my friends list as JSON document" do
      #setup
      allow(RestClient).to receive(:post)
        .and_return(stubbed_sign_in_response)

      allow(RestClient::Request).to receive(:execute)
        .with(hash_including(url:/friendships\/me/))
        .and_return(friends_stubbed_response)

      allow(RestClient::Request).to receive(:execute)
        .with(hash_including(url:/users\/me/))
        .and_return(user_stubbed_response)

      #exercise
      get :export, user: "my_user@me", password: "my_password"

      data_return = JSON.parse(response.body) # Parsing JSON response

      #verify
      expect(data_return["count"]).to eq 5
      expect(data_return["user"]).to_not be_nil
      expect(data_return["user"]["name"]).to eq "henriqueelias" # Checking current user info
      expect(data_return["user"]["email"]).to eq "hcbe2004@gmail.com" # Checking current user info
      expect(data_return["user"]["socialPercentage"]).to_not be_nil
      expect(data_return["user"]["socialType"]).to_not be_nil
      expect(data_return["friends"]).to_not be_nil # Checking frined's current user
      expect(data_return["friends"].length).to eq data_return["count"]# Checking frined's current user
    end

    context "And I have more than 15 friends on it" do
      it "Then the social percentage attribute should show \"100%\" (pecentage included)" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute).with(hash_including(url:/friendships\/me/)).and_return(friends_15_stubbed_response)

        allow(RestClient::Request).to receive(:execute).with(hash_including(url:/users\/me/)).and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        #verify
        expect(data_return["count"]).to be >= 15
        expect(data_return["user"]["socialPercentage"]).to eq "100%"
      end
    end
    context "And I have 10 friends on my friends list" do
      it "Then the social percentage attribute should show \"66%\"" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/friendships\/me/))
          .and_return(friends_10_stubbed_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/users\/me/))
          .and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        #verify
        expect(data_return["count"]).to eq 10
        expect(data_return["user"]["socialPercentage"]).to eq "66%"
      end
    end
    context "And my social percentage is greater than 80%" do
      it "Then the social type attribute should say \"Super Friendly\" (capitalized)" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/friendships\/me/))
          .and_return(friends_13_stubbed_response) # 12 friends => SocialPercentage = 80%

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/users\/me/))
          .and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        #verify
        expect(data_return["count"]).to eq 13
        expect(data_return["user"]["socialPercentage"]).to be > "80%"
        expect(data_return["user"]["socialType"]).to eq "Super Friendly"
      end
    end
    context "And my social percentage is equals to 80%" do
      it "Then the social type attribute should say \"Friendly\" (capitalized)" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/friendships\/me/))
          .and_return(friends_12_stubbed_response) # 12 friends => SocialPercentage = 80%

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/users\/me/))
          .and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        #verify
        expect(data_return["count"]).to eq 12
        expect(data_return["user"]["socialPercentage"]).to eq "80%"
        expect(data_return["user"]["socialType"]).to eq "Friendly"
      end
    end
    context "And my social percentage is equals to 80%" do
      it "Then the social type attribute should say \"Friendly\" (capitalized)" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/friendships\/me/))
          .and_return(friends_12_stubbed_response) # 12 friends => SocialPercentage = 80%

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/users\/me/))
          .and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        #verify
        expect(data_return["count"]).to eq 12
        expect(data_return["user"]["socialPercentage"]).to eq "80%"
        expect(data_return["user"]["socialType"]).to eq "Friendly"
      end
    end
    context "And my social percentage is lower than 30%" do
      it "Then the social type attribute should say \"Not So Friendly\" (capitalized)" do
        #setup
        allow(RestClient).to receive(:post).and_return(stubbed_sign_in_response)

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/friendships\/me/))
          .and_return(friends_2_stubbed_response) # 2 friends => SocialPercentage = 13%

        allow(RestClient::Request).to receive(:execute)
          .with(hash_including(url:/users\/me/))
          .and_return(user_stubbed_response)

        #exercise
        get :export, user: "my_user@me", password: "my_password"

        data_return = JSON.parse(response.body) # Parsing JSON response
        p data_return
        #verify
        expect(data_return["count"]).to eq 2
        expect(data_return["user"]["socialPercentage"]).to eq "13%"
        expect(data_return["user"]["socialType"]).to eq "Not So Friendly"
      end
    end
  end
end
