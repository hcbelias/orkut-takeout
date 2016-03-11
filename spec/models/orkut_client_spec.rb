require 'rails_helper'

describe OrkutClient do
  let(:orkut_client) { OrkutClient.new }

  let(:sign_in_response){
    sign_in_response = double()
    allow(sign_in_response).to receive(:body).and_return("my token")
    sign_in_response
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
    expect { client.sign_in("invalid@invalid.com","invalid") }.to raise_error(Exception)
  end

end
