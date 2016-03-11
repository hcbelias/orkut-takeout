require 'rails_helper'

describe XMLExporter
  let(:exporter) {  XMLExporter.new }
  let(:current_user_hash) {
    {
      "_id"=>"56df404693a9a845256d305b",
      "provider"=>"local",
      "name"=>"henriqueelias",
      "email"=>"hcbe2004@gmail.com",
      "password"=>"201286",
      "__v"=>0,
      "role"=>"user"
    }
  }

  let(:friends_hash){
    JSON.parse(%Q([{"_id":"56ab7fc22e481306042c151d","user":{"_id":"56ab7ee72e481306042c1518","name":"QA Couse User 1","email":"qacourseuser1@avenuecode.com"}},{"_id":"56ab7fd22e481306042c151e","user":{"_id":"56ab7ef12e481306042c1519","name":"QA Couse User 2","email":"qacourseuser2@avenuecode.com"}},{"_id":"56ab7fd82e481306042c151f","user":{"_id":"56ab7efb2e481306042c151a","name":"QA Couse User 3","email":"qacourseuser3@avenuecode.com"}},{"_id":"56ab7fe22e481306042c1520","user":{"_id":"56ab7f042e481306042c151b","name":"QA Couse User 4","email":"qacourseuser4@avenuecode.com"}},{"_id":"56ab7fec2e481306042c1521","user":{"_id":"56ab7f102e481306042c151c","name":"QA Couse User 5","email":"qacourseuser5@avenuecode.com"}}]))
  }

  it "should return a header on the first line of the file" do
    csv_return   = exporter.export_friends
    expect(csv_return).to start_with "my_name,my_email,friend_name,friend_email\n"
  end

  context "should export my friends in XML format" do
    it "should say my social type is SOCIABLE" do
      xml_return = exporter.export_friends(friends_hash, current_user_hash)
      expect(xml_return).to include "henriqueelias,hcbe2004@gmail.com"
    end
    it "should include my friends email and password" do
      csv_return = exporter.export_friends(friends_hash, current_user_hash)
      expect(csv_return).to include "QA Couse User 1,qacourseuser1@avenuecode.com"
    end
  end

end
