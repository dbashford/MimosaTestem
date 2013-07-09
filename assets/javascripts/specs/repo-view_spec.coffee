define ['jquery',
  'app/repo-view'
  './data-helper'],
($, RepoView, data) ->

  view = null
  $button = null
  $input = null

  before ->
    # set up necessary DOM
    $('body').append("<input id='spec_test_input' /><button id='spec_test_button' /><div id='results'></div>");
    view = new RepoView()

    $button = $('button')
    $input = $('input')

  after ->
    # clean up created DOM
    $('[id^=spec_test_]').remove()

  describe 'when the button is clicked', ->

    searchStub = null

    beforeEach ->
      searchStub = sinon.stub view, "executeSearch"

    afterEach ->
      searchStub.restore()

    it 'and there is no value in the box, search should not be called', ->
      $input.val('')
      $button.click()
      expect(searchStub.called).to.be.false

    it 'and there is a value in the box, search should be called', ->
      $input.val('foo')
      $button.click()
      expect(searchStub.called).to.be.true

  describe 'when search is executed', ->

    setupSearch = ->
      xhr = sinon.useFakeXMLHttpRequest()
      xhr.onCreate = (xhr) ->
        requests.push(xhr)
      requests = []
      buildResultsStub = sinon.stub view, "buildResults"
      renderStub = sinon.stub view, "render"
      view.executeSearch("foo")
      [xhr, requests, buildResultsStub, renderStub]

    teardownSearch = (xhr, buildResultsStub, renderStub) ->
      xhr.restore()
      buildResultsStub.restore()
      renderStub.restore()

    describe 'and the owner does not exist', ->

      xhr = null
      requests = null
      buildResultsStub = null
      renderStub = null

      before ->
        [xhr, requests, buildResultsStub, renderStub] = setupSearch()
        requests[0].respond 404,
          {"Content-Type": "application/json"},
          '{"message": "Not Found"}'

      after ->
        teardownSearch(xhr, buildResultsStub, renderStub)

      it 'should have made one ajax request', ->
        expect(requests.length).to.equal(1);

      it 'results should be built with an empty array', ->
        expect(buildResultsStub.calledOnce).to.be.true
        expect(buildResultsStub.args[0][0].length).to.equal(0)

      it 'render should be called', ->
        expect(renderStub.called).to.be.true

    describe 'and the owner exists', ->
      xhr = null
      requests = null
      buildResultsStub = null
      renderStub = null

      before ->
        [xhr, requests, buildResultsStub, renderStub] = setupSearch()
        requests[0].respond 200,
          {"Content-Type": "application/json"},
          JSON.stringify(data.fullRepoResult)

      after ->
        teardownSearch(xhr, buildResultsStub, renderStub)

      it 'should have made one ajax request', ->
        expect(requests.length).to.equal(1);

      it 'results should be built with an empty array', ->
        expect(buildResultsStub.calledOnce).to.be.true
        expect(buildResultsStub.args[0][0].length).to.equal(30)

      it 'render should be called', ->
        expect(renderStub.called).to.be.true

  describe 'when results are built they should contain', ->

    results = null

    before ->
      results = view.buildResults data.fullRepoResult, data.fakeXhr("10"), "foo"

    it 'repo owner results', ->
      expect(results.results.length).to.equal(25)

    it 'the queried owner name', ->
      expect(results.name).to.equal("foo")

    describe 'the rate limiting information', ->

      it 'when the user has not been limited', ->
        expect(results.limit).to.equal("60")
        expect(results.remaining).to.equal("10")
        expect(results.limited).to.be.false

      it 'when the user has been limited', ->
        limitedResults = view.buildResults data.fullRepoResult, data.fakeXhr("0"), "foo"
        expect(limitedResults.limit).to.equal("60")
        expect(limitedResults.remaining).to.equal("0")
        expect(limitedResults.limited).to.be.true
        expect(limitedResults.canUseWhen).to.equal("in 2 minutes")

  describe 'data processing', ->

    results = null

    before ->
      results = view.processData data.fullRepoResult

    it 'should limit results to 25', ->
      expect(results.length).to.equal(25)

    it 'should pull out the pertinent information', ->
      for result in results
        expect(Object.keys(result).length).to.equal(3)
        expect(result.name).to.exist
        expect(result.url).to.exist
        expect(result.desc).to.exist

  describe 'when rendering', ->

    describe 'with results', ->

      viewData = null

      before ->
        viewData = data.viewDataResults()
        view.render viewData

      after ->
        $('#results').empty()

      it 'should show the repo owner searched', ->
        expect($('#repo-owner').html()).to.equal('foo')

      it 'should show the limiting information', ->
        expect($('#limiting-information').length).to.equal(1)

      describe 'when not rate limited', ->

        it 'should not show the limiting alert', ->
          expect($('#shutdown').length).to.equal(0)

      describe 'should show a result list', ->

        $listItems = null

        before ->
          $listItems = $('#result-list li')

        it 'with the correct number of entries', ->
          expect($listItems.length).to.equal(30)

        it 'with each result containing a link to the repo', ->
          expect($listItems.find('a').length).to.equal(30)

    describe 'with no results', ->

      viewData = null

      before ->
        viewData = data.viewDataNoResults()
        view.render viewData

      after ->
        $('#results').empty()

      it 'should show the owner owner searched', ->
        expect($('#repo-owner').html()).to.equal('foo')

      it 'should show the limiting information', ->
        expect($('#limiting-information').length).to.equal(1)

      it 'should show that the owner is unknown to github', ->
        expect($('#unknown-owner').length).to.equal(1)

    describe 'when rate limited', ->
      viewData = null

      before ->
        viewData = data.viewDataRateLimited()
        view.render viewData

      after ->
        $('#results').empty()

      it 'should not have a result list', ->
        expect($('#result-list').length).to.equal(0)

      it 'should show the rate limited alert', ->
        expect($('#shutdown').length).to.equal(0)

