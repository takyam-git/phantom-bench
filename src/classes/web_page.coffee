check = require('validator').check
_ = require('underscore')

class WebPage
  @phantom = require('phantom')

  _url: null
  _results: []

  _viewportSize: {width: 1024, height: 768}

  constructor: (url)->
    @_url = null
    @_results = []
    @setUrl(url)

  ###
  # Set url to this instance
  # @param {String} url
  # @returns {Boolean} return false if argument is not valid url string
  ###
  setUrl: (url)=>
    try
      check(url).isUrl()
      @_url = url
      return true
    catch error
      @_url = null
    return false

  ###
  # load webpage
  # @param {String} [url=null] Request target web page URL.
  # @param {Function} [cb=null] Callback function. Arguments are (status, speed).
  ###
  load: (url = null, cb = null)=>
    if url
      if typeof url is 'function'
        cb = url
        url = null
      else
        @setUrl(url)

    return false unless @_url

    WebPage.phantom.create (ph)=>
      ph.createPage (page)=>
        page.set('viewportSize', @_viewportSize)
        startTime = Date.now()
        page.open @_url, (status)=>
          speed = Date.now() - startTime
          @_results.push status: status, speed: speed
          ph.exit()
          cb(status, speed) if typeof cb is 'function'

    return true

  ###
  # return last request result
  # @returns {{status: String, speed: Number}|null}
  ###
  getLastResult: =>
    return if @_results.length > 0 then _.last(@_results) else null

  ###
  # return last request speed
  # @returns {Number|null}
  ###
  getLastSpeed: =>
    lastResult = @getLastResult()
    return if lastResult and lastResult?.speed? then lastResult.speed else null

  ###
  # return last request status
  # @returns {String|null}
  ###
  getLastStatus: =>
    lastResult = @getLastResult()
    return if lastResult and lastResult.status? then lastResult.status else null


module.exports = WebPage