require
  urlArgs: "b=#{new Date().getTime()}"
  paths:
    jquery: 'vendor/jquery'
    lodash: 'vendor/lodash'
    moment: 'vendor/moment'
  , ['app/repo-view']
  , (OwnerRepoListView) ->
    new OwnerRepoListView().searchOwner()