require "test_helper"

describe ApplicationHelper do
  let(:one) { products(:one)}
  describe "format price" do
    it "formats price to a dollar value" do
      price = 77.5
      format_price(price).must_equal "$77.50"
      format_price(price).must_be_kind_of String
    end
  end
  describe "format date" do
    it "returns a readable date" do
      date = DateTime.new(2012, 07, 11, 20, 10, 0)
      format_date(date).must_include "Wednesday, Jul 11"
    end
  end
  describe "format time" do
    it "returns a readable time" do
      time = DateTime.new(2012, 07, 11, 20, 10, 0)
      format_time(time).must_include "8:10 pm"
    end
  end

end
