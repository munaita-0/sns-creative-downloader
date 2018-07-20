require 'mechanize'
require 'selenium-webdriver'
require 'open-uri'

url = ARGV[0]

driver = Selenium::WebDriver.for :chrome
driver.get url

#ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
element = wait.until { driver.find_element(:tag_name => "img") }

# sourceをファイルに書き込む
File.open('tw.source', 'w') do |f|
  f.puts(driver.page_source)
end

doc = File.open("tw.source") { |f| Nokogiri::HTML(f) }

# both
count = 0
doc.css(".Tweet--web").each do |t|
  text = t.css('.Tweet-text').to_s
  img = t.css('.Card-image')[0]

  next if img.nil?

  puts img

  open(img['src']) do |image|
    File.open("tw_files/#{count}.img.jpg","wb") do |file|
      file.puts image.read
    end

    File.open("tw_files/#{count}.txt", "w") do |f|
      f.puts(text)
    end

    count = count + 1
  end
end

driver.quit
