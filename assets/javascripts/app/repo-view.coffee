define ['jquery',
  'lodash',
  'moment',
  'templates'],
($, _, moment, templates) ->

  class OwnerRepoListView

    constructor: ->
      $('button').click(@searchOwner)
      $('input').keyup(@searchCheck)

    searchCheck: (e) =>
      @searchOwner() if e.keyCode is 13

    searchOwner: =>
      repoName = $('input').val()
      if repoName.length > 0
        @executeSearch repoName

    executeSearch: (repo) ->
      url = "https://api.github.com/users/#{repo}/repos?type=owner&sort=updated&date=#{new Date().getTime()}"
      $.getJSON(url).success(@searchSuccess repo).fail(@searchFail repo)

    searchSuccess: (repo) ->
      (data, status, xhr) =>
        results = @buildResults data, xhr, repo
        @render results

    searchFail: (repo) ->
      (xhr) =>
        results = @buildResults [], xhr, repo
        @render results

    buildResults: (data, xhr, repo) ->
      processedData = @processData data
      rateLimitingData = @rateLimiting xhr.getResponseHeader
      _.extend {results: processedData, name:repo}, rateLimitingData

    rateLimiting: (rhs) ->
      limit: rhs 'X-RateLimit-Limit'
      remaining: rhs 'X-RateLimit-Remaining'
      limited: rhs('X-RateLimit-Remaining') is "0"
      canUseWhen: moment(new Date(rhs('X-RateLimit-Reset') * 1000)).fromNow()

    processData: (data) ->
      if data.length > 25
        data = _.initial data, data.length - 25

      _.map data, (result) ->
        name: result.name
        url:  result.html_url
        desc: result.description

    render: (data) ->
      $('#results').html templates.results(data)