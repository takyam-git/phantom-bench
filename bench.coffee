request = require('request')
WebPage = require("#{__dirname}/src/classes/web_page.coffee")
DELAY = 60000

PAGES = [
  {name: 'google', url: 'http://www.google.co.jp/'}
  {name: 'yahoo', url: 'http://www.yahoo.co.jp/'}
  {name: 'youtube', url: 'http://www.youtube.com/'}
  {name: 'rakuten', url: 'http://www.rakuten.co.jp/'}
  {name: 'amazon', url: 'http://www.amazon.co.jp/'}
]

return if PAGES.length <= 0

currentKey = 0

bench = ->
  currentKey = 0 unless PAGES[++currentKey]?
  page = new WebPage(PAGES[currentKey].url)
  page.load (status, speed)->
    if status is 'success'
      request.post {url:"http://localhost:5125/api/pagespeed/sites/#{page.name}", form:{number: speed}}, (err, r, body)->
        setTimeout(bench, 1000)

bench()