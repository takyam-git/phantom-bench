WebPage = require('../../src/classes/web_page.coffee')

describe 'WebPageクラスのコンストラクタ周り', ->
  page = null
  validUrl = 'http://example.com/'

  it 'コンストラクタに何も渡さないとURLにはnullがセットされるよ', ->
    page = new WebPage()
    assert.instanceOf(page, WebPage)
    assert.isNull(page._url)

  it 'コンストラクタにURL渡すとプライベートプロパティにセットされるよ', ->
    page = new WebPage(validUrl)
    assert.strictEqual(page._url, validUrl)

  it 'コンストラクタに不正なURL渡すとURLはnullのママだよ', ->
    page = new WebPage('THIS IS NOT HTTP')
    assert.isNull(page._url)

  it '後からsetUrl()でURLを変更できるようになってるよ', ->
    page = new WebPage()
    assert.isNull(page._url)
    page.setUrl(validUrl)
    assert.strictEqual(page._url, validUrl)
    
  it '一度セットしたURLの後に不正なURLをセットしようとするとURLはNULLになるよ', ->
    page = new WebPage(validUrl)
    assert.strictEqual(page._url, validUrl)
    page.setUrl('hogeoge-fugafuga-')
    assert.isNull(page._url)

describe "WebPage.load()がちゃんと動くかなー", ->
  validUrl = 'http://example.com/'
  before ->
    sinon.spy(WebPage.phantom, 'create')
  after ->
    WebPage.phantom.create.restore()
  it '不正なURL渡した状態でload()してもfalseが帰ってきてresultsは増えないよ', ->
    page = new WebPage('hogehoge')
    assert.lengthOf(page._results, 0)
    assert.isFalse(page.load())
    assert.lengthOf(page._results, 0)
  it '正しいURLを渡した状態でload()するとtrueが帰ってきてresultsは増えるよ', ->
    page = new WebPage(validUrl)
    assert.lengthOf(page._results, 0)
    assert.isTrue(page.load())

    sinon.assert.calledOnce(WebPage.phantom.create)
    sinon.assert.calledWithMatch(WebPage.phantom.create, sinon.match.func)
    createCallback = WebPage.phantom.create.getCall(0).args[0]

    phSpy =
      createPage: sinon.spy()
      exit: sinon.spy()

    createCallback(phSpy)

    sinon.assert.calledOnce(phSpy.createPage)
    sinon.assert.calledWithMatch(phSpy.createPage, sinon.match.func)

    createPageCallback = phSpy.createPage.getCall(0).args[0]

    pageSpy =
      set: sinon.spy()
      open: sinon.spy()

    createPageCallback(pageSpy)

    sinon.assert.calledOnce(pageSpy.set)
    sinon.assert.calledWithMatch(pageSpy.set, 'viewportSize', sinon.match.object)

    sinon.assert.calledOnce(pageSpy.open)
    sinon.assert.calledWithMatch(pageSpy.open, validUrl, sinon.match.func)

    openCallback = pageSpy.open.getCall(0).args[1]
    openCallback('expectStatus')

    sinon.assert.calledOnce(phSpy.exit)
    sinon.assert.calledWith(phSpy.exit)

    assert.lengthOf(page._results, 1)
    assert.isObject(page._results[0])
    assert.property(page._results[0], 'status')
    assert.property(page._results[0], 'speed')
    assert.strictEqual(page._results[0].status, 'expectStatus')
    assert.isNumber(page._results[0].speed)

describe 'WebPageクラスのゲッターの挙動チェック', ->
  page = null
  beforeEach (done)->
    page = new WebPage()
    done()
  it '一度もloadしてない時にgetLastResultsよんだらnull返ってくる', ->
    assert.isNull(page.getLastResult())
  it 'getLastResultsは_resultsの最後の要素を返すよ。', ->
    page._results = ['A', 'B', 'C']
    assert.strictEqual(page.getLastResult(), 'C')
    page._results.push('X')
    assert.strictEqual(page.getLastResult(), 'X')
  it 'getLastSpeedは最後の結果のspeedを返すよ', ->
    page._results = [{status: 'A', speed: 10}, {status: 'B', speed: 15}]
    assert.strictEqual(page.getLastSpeed(), 15)
    page._results.push({status: 'X', speed: 99})
    assert.strictEqual(page.getLastSpeed(), 99)
  it '一度もloadしてない時にgetLastSpeedよんだらnull返ってくる', ->
    assert.isNull(page.getLastSpeed())
  it '変なのが_resultsに入ってるときにgetLastSpeedしてもnull返ってくるよ', ->
    page._results.push({hoge: 'fuga'})
    assert.isNull(page.getLastSpeed())
  it 'getLastStatusは最後の結果のspeedを返すよ', ->
    page._results = [{status: 'A', speed: 10}, {status: 'B', speed: 15}]
    assert.strictEqual(page.getLastStatus(), 'B')
    page._results.push({status: 'X', speed: 99})
    assert.strictEqual(page.getLastStatus(), 'X')
  it '一度もloadしてない時にgetLastStatusよんだらnull返ってくる', ->
    assert.isNull(page.getLastStatus())
  it '変なのが_resultsに入ってるときにgetLastStatusしてもnull返ってくるよ', ->
    page._results.push({hoge: 'fuga'})
    assert.isNull(page.getLastStatus())
