require 'base64'
require 'json'
require 'selenium-webdriver'
require 'clipboard'

base64 = []
res = []

Dir[Dir.pwd + '/qrcode/*'].each { |n|
    base64.push('data:image/png;base64,' + Base64.encode64(File.open(n, 'rb').read))
}

options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options

driver.get 'https://zxing.org/w/decode.jspx'

base64.each { |n|
    Clipboard.copy n
    sleep(1.7)
    elem = driver.find_element(:xpath => '//*[@id="u"]')
    sleep(1.7)
    elem.send_keys [:control, 'a']
    elem.send_keys [:backspace]
    elem.send_keys [:control, 'v']
    sleep(1.7)
    driver.find_element(:xpath => '//*[@id="upload"]/tbody/tr[1]/td[3]/input').click
    sleep(1.7)
    result = driver.find_element(:xpath => '/html/body/div/table/tbody/tr[5]/td[2]/pre')
    sleep(1.7)

    res.push(result.text)
    driver.navigate.back
}

File.open(Dir.pwd + '/result.json', 'w') do |f|
    f.write(JSON.pretty_generate(res))
end

puts('sucess')
