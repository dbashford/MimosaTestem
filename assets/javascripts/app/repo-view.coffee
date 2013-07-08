define ['jquery', 'lodash', 'moment', 'templates'],
($, _, moment, templates) ->

  class RepoListView

    constructor: ->
      $('button').click =>
        repoName = $('input').val()
        if repoName.length > 0
          @search repoName

    search: (repo = "dbashford") ->
      url = "https://api.github.com/users/#{repo}/repos?type=owner&sort=updated&date=#{new Date().getTime()}"
      $.getJSON(url).success (data, status, xhr) =>
        @render @buildResults(data, xhr, repo)
      .fail (xhr) =>
        @render @buildResults([], xhr, repo)

    buildResults: (data, xhr, repo) ->
      _.extend {results: @process data, name:repo}, @rateLimiting xhr.getResponseHeader

    rateLimiting: (rhs) ->
      limit: rhs 'X-RateLimit-Limit'
      remaining: rhs 'X-RateLimit-Remaining'
      limited: rhs('X-RateLimit-Remaining') is "0"
      canUseWhen: moment(new Date(rhs('X-RateLimit-Reset') * 1000)).fromNow()

    process: (data) ->
      if data.length > 25
        data = _.initial data, data.length - 25

      _.map data, (result) ->
        name: result.name
        url:  result.html_url
        desc: result.description

    render: (data) ->
      $('#results').html templates.results(data)