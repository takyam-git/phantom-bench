Request = require('../../src/request/request.coffee')

describe 'hoge', ->
  it 'fuga', ->
    request = new Request()
    assert.instanceOf(request, Request)