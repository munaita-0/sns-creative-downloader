#!/usr/bin/ruby
require 'selenium-webdriver'

##プロキシが必要な場合
#PROXY = 'proxy.example.com:8080'
#profile = Selenium::WebDriver::Firefox::Profile.new
#profile.proxy = Selenium::WebDriver::Proxy.new(
#  :http     => PROXY,
#  :ftp      => PROXY,
#  :ssl      => PROXY
#)

#Selenium Driver経由でChromeを呼び出す
driver = Selenium::WebDriver.for :chrome

#Googleに遷移する
driver.get "https://ads.twitter.com/transparency/UNIQLO_JP"

#ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
begin
  # htmlを解析しid=some-dynamic-elementがあるかチェック
  element = wait.until { driver.find_element(:class => "Card-imageContainer") }
  File.open('hoge.txt', 'w') do |f|
    f.puts(driver.page_source)
  end
ensure
  # wait-timeoutで見つからなかったら、ドライバを解放しブラウザを閉じる
  driver.quit
end

sleep 3
driver.close
