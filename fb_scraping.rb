require 'mechanize'
require 'selenium-webdriver'
require 'open-uri'

email = ENV['FB_EMAIL']
pass = ENV['FB_PASS']
url = ARGV[0]

agent = Mechanize.new
agent.user_agent_alias = 'Mac Mozilla'
login_page = agent.get('https://facebook.com/')
login_form = agent.page.form_with(:method => 'POST')
login_form.email = email
login_form.pass = pass
agent.submit(login_form)

ad_page = agent.get(url)

# sourceをファイルに書き込む
File.open('fb.source', 'w') do |f|
  f.puts(ad_page.body)
end

doc = File.open("fb.source") { |f| Nokogiri::HTML(f) }

count = 0
doc.xpath("//img").each do |i|
  p i['src']
  next unless (i['class'].include?('scaledImageFitWidth') || i['class'].include?('_kvn'))
  open(i['src']) do |image|
    File.open("fb_files/#{count}.img.jpg","wb") do |file|
      file.puts image.read
    end
    count = count + 1
  end
end
