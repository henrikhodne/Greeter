require "rspec"
require "selenium-webdriver"

server_url = "http://127.0.0.1:4723/wd/hub"

describe "Greeter" do
  before :all do
    @driver = Selenium::WebDriver.for(:remote, desired_capabilities: { 'browserName' => 'iOS', 'platform' => 'Mac', 'version' => '6.1' }, url: server_url)
  end

  after :all do
    @driver.quit
  end

  it "should display 'Hello, world!' on screen" do
    greeting = @driver.find_elements(:tag_name, 'staticText')[0].text
    expect(greeting).to eq("Hello, world!")
  end
end
