define ['jquery',
  'lodash',
  'app/repo-view'],
($, _, RepoView) ->

  view = null

  before ->
    # set up necessary DOM
    $('body').append("<input id='spec_test_input' /><button id='spec_test_button' />");
    view = new RepoView()

  after ->
    # clean up created DOM
    $('[id^=spec_test_]').remove()

  describe 'when the button is pressed', ->

    it 'and there is no value in the box, search should not be called', ->

    it 'and there is a value in the box, search should be called', ->

  describe 'when search is called', ->

    describe 'with no arguments', ->

      it 'a default repo should be used', ->

    describe 'with arguments', ->

      describe 'and the repo does not exist', ->

        it 'searchFail should be called', ->

        it 'results should be built with an empty array', ->

        it 'render should be called', ->

      describe 'and the repo exists', ->

        it 'searchSuccess should be called', ->

        it 'results should be built with an array containing entries', ->

        it 'render should be called', ->

  describe 'when results are built they should contain', ->

    it 'rate limiting information', ->

    it 'the queried repo name', ->

    it 'the rate limiting information', ->

  describe 'the rate limiting information', ->

    it 'correctly report when the user has been limited'

  describe 'data processing', ->

    it 'should limit results to 25', ->

    it 'should pull out the pertinent information', ->

  describe 'when rendering', ->

    describe 'with no results', ->

      it 'should show the repo owner searched', ->

      it 'should show the limiting information', ->

      it 'should show that the owner is unknown to github', ->

    describe 'with results', ->

      it 'should show the repo owner searched', ->

      it 'should show the limiting information', ->

      describe 'should show a result list', ->

        it 'with the correct number of entries', ->

        it 'with each result containing a link to the repo', ->

    describe 'when rate limited', ->

      it 'should not have a result list', ->

      it 'should show the rate limited alert', ->
