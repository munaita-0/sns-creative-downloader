require 'mechanize'
require 'selenium-webdriver'
require 'open-uri'

# url = 'https://www.facebook.com/pg/g.u.japan/ads/?ref=page_internal'
url = 'https://ads.twitter.com/transparency/UNIQLO_JP'
# url = 'https://ads.twitter.com/transparency/suntory'

driver = Selenium::WebDriver.for :chrome
driver.get url

#ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
begin
  # htmlを解析しid=some-dynamic-elementがあるかチェック
  element = wait.until { driver.find_element(:class => "Card-imageContainer") }
  
  # sourceをファイルに書き込む
  File.open('source.html', 'w') do |f|
    f.puts(driver.page_source)
  end

  doc = File.open("source.html") { |f| Nokogiri::HTML(f) }

  # both
  count = 0
  doc.css(".Tweet--web").each do |t|
    text = t.css('.Tweet-text').to_s
    img = t.css('.Card-image')[0]

    next if img.nil?

    puts img

    open(img['src']) do |image|
      File.open("files/#{count}.img.jpg","wb") do |file|
        file.puts image.read
      end

      File.open("files/#{count}.txt", "w") do |f|
        f.puts(text)
      end

      count = count + 1
    end
  end

ensure
  # wait-timeoutで見つからなかったら、ドライバを解放しブラウザを閉じる
  driver.quit
end

sleep 3
driver.close
