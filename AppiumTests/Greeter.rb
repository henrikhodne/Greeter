require "rspec"
require "selenium-webdriver"
require "json"
require "rest_client"

APP_PATH = "sauce-storage:Greeter.app.zip"
SAUCE_USERNAME = ENV["SAUCE_USERNAME"]
SAUCE_ACCESS_KEY = ENV["SAUCE_ACCESS_KEY"]
AUTH_DETAILS = "#{SAUCE_USERNAME}:#{SAUCE_ACCESS_KEY}"

describe "Greeter" do
  before :each do
    @driver = Selenium::WebDriver.for(:remote, desired_capabilities: capabilities, url: server_url)
  end

  after :each do
    job_id = @driver.send(:bridge).session.id
    update_job_success(job_id, example.exception.nil?)
    @driver.quit
  end

  it "should display 'Hello, world!' on screen" do
    greeting = @driver.find_elements(:tag_name, 'staticText')[0].text
    expect(greeting).to eq("Hello, world!")
  end
end

def capabilities
  {
    "browserName" => "iOS 6.1",
    "platform" => "Mac 10.8",
    "device" => "iPhone Simulator",
    "app" => APP_PATH,
    "name" => "Greeter tests for Appium",
  }
end

def server_url
  "http://#{AUTH_DETAILS}@ondemand.saucelabs.com:80/wd/hub"
end

def rest_jobs_url
  "https://#{AUTH_DETAILS}@saucelabs.com/rest/v1/#{SAUCE_USERNAME}/jobs"
end

# Because WebDriver doesn't have the concept of test failure, use the Sauce
# Labs REST API to record job success or failure
def update_job_success(job_id, success)
    RestClient.put "#{rest_jobs_url}/#{job_id}", {"passed" => success}.to_json, :content_type => :json
end
