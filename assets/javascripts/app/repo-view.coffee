define ['jquery', 'lodash', 'moment', 'templates'],
($, _, moment, templates) ->

  class RepoListView

    constructor: ->
      $('button').click =>
        repoName = $('input').val()
        if repoName.length > 0
          @search repoName

    search: (repo = "dbashford") ->
      url = "https://api.github.com/users/#{repo}/repos?type=owner&sort=updated"
      $.getJSON(url).always (data, status, xhr) =>
        results = _.extend {results: @process data, name:repo}, @rateLimiting xhr.getResponseHeader
        @render results

    rateLimiting: (rhs) ->
      limit: rhs 'X-RateLimit-Limit'
      remaining: rhs 'X-RateLimit-Remaining'
      limited: rhs('X-RateLimit-Remaining') is 0
      canUseWhen: moment(new Date(rhs('X-RateLimit-Reset') * 1000)).fromNow()

    process: (data) ->
      return [] unless data

      if data.length > 25
        data = _.initial data, data.length - 25

      _.map data, (result) ->
        name: result.name
        url:  result.html_url
        desc: result.description

    render: (data) ->
      html = templates.results data
      $('#results').html html