require 'rails_helper'

RSpec.describe Hello, type: :model do
  it "is valid with title, text" do
    hello = Hello.new(
      hello: "こんばんわに",
      content:"ちゃす"
      )
    expect(hello).to be_valid
  end
end
