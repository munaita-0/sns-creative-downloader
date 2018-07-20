require 'mechanize'
require 'selenium-webdriver'
require 'open-uri'

# url = 'https://www.facebook.com/pg/g.u.japan/ads/?ref=page_internal'
url = 'https://ads.twitter.com/transparency/UNIQLO_JP'
# url = 'https://ads.twitter.com/transparency/suntory'

#Selenium Driver経由でChromeを呼び出す
driver = Selenium::WebDriver.for :chrome

#Googleに遷移する
driver.get url

#ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
begin
  # htmlを解析しid=some-dynamic-elementがあるかチェック
  element = wait.until { driver.find_element(:class => "Card-imageContainer") }
  
  # sourceをファイルに書き込む
  File.open('source.txt', 'w') do |f|
    f.puts(driver.page_source)
  end

  doc = File.open("source.txt") { |f| Nokogiri::HTML(f) }

  # img
  # count = 0
  # doc.xpath('//img').each do |i|
  #   next if i['class'] == 'Tweet-avatar'
  #   next if i['class'] == 'Card-ownerAvatar'
  #   p i['src']
  #   p i['class']
  #   open(i['src']) do |image|
  #     File.open("#{count}.img.jpg","wb") do |file|
  #       file.puts image.read
  #     end
  #     count = count + 1
  #   end
  # end

  # text
  # doc.css(".Tweet-text").each do |t|
  #   puts t
  # end

  # both
  count = 0
  doc.css(".Tweet--web").each do |t|
    text = t.css('.Tweet-text').to_s
    t.xpath('//img').each do |i|
      next if i['class'] == 'Tweet-avatar'
      next if i['class'] == 'Card-ownerAvatar'

      p i['src']

      open(i['src']) do |image|
        File.open("#{count}.img.jpg","wb") do |file|
          file.puts image.read
        end
      
        File.open("#{count}.txt", "w") do |f|
          f.puts(text)
        end
      
        count = count + 1
      end
    end
    p '=========='
  end


ensure
  # wait-timeoutで見つからなかったら、ドライバを解放しブラウザを閉じる
  driver.quit
end

sleep 3
driver.close

# Facebook
# agent = Mechanize.new
# agent.user_agent_alias = 'Android'
# login_page = agent.get('https://m.facebook.com/')
# login_form = agent.page.form_with(:method => 'POST')
# login_form.email = 'shogo807@gmail.com'
# login_form.pass = '1995abcd'
# agent.submit(login_form)

agent = Mechanize.new
# page = agent.get(url)

# page.links.each do |link|
#   p link.text
# end

# page.images_with(:src => /jpg\Z/).each do |img|
# page.images.each do |img|
#   p 'aaaaaaaa'
#   p img.to_s
# end
#
# page.search('img').each do |i|
#   p 'bb'
#   p i.to_s
# end
