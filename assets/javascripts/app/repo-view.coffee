define ['jquery',
  'lodash',
  'moment'
  'templates'],
($, _, moment, templates) ->

  class RepoListView

    constructor: ->
      @workflow()

      $('button').click =>
        repoName = $('input').val()
        if repoName.length > 0
          @workflow repoName

    workflow: (repoName = "dbashford") ->
      @search repoName, (results) =>
        @process results
        @render results

    search: (repo, cb) ->
      url = "https://api.github.com/users/#{repo}/repos?type=owner&sort=updated"
      $.getJSON(url).always (data, status, xhr) =>
        cb results:data, limit: @rateLimiting xhr

    rateLimiting: (xhr) ->
      rateLimitData =
        limit: xhr.getResponseHeader 'X-RateLimit-Limit'
        remaining: xhr.getResponseHeader 'X-RateLimit-Remaining'
      if rateLimitData.remaining is 0
        rateLimitData.canUseWhen = moment(new Date(xhr.getResponseHeader('X-RateLimit-Reset') * 1000)).fromNow()
      rateLimitData

    process: (data) ->
      if data.results.length > 25
        data.results = _.initial data.results, data.results.length - 25

      data.results = _.map data.results, (result) ->
        name: result.name
        url:  result.html_url
        desc: result.description

    render: (data) ->
      html = templates.results results:data.results
      $('#results').html html

  RepoListView