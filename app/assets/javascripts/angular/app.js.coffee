repoItemsApp = angular.module('repoItemsApp', ['controllers', 'templates', 'ngRoute', 'ngResource'])

repoItemsApp.config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/', {
    templateUrl: 'repo_items.html'
    controller: 'IndexRepoItemsCtrl'
  }).when('/:id', {
    templateUrl: 'repo_items.html'
    controller: 'ShowRepoItemsCtrl'
  })
  .otherwise({redirectTo: '/'})
  $locationProvider.html5Mode(true);
)
repoItemsApp.service('RepoItem', ['$resource', ($resource) ->
  $resource('/api/groups/1/repo_items/:id.json', {}, {
    query: {method: 'GET', params: {id: ''}, isArray: true}
  })
])

controllers = angular.module('controllers',[])
controllers.controller('IndexRepoItemsCtrl', ['RepoItem', '$scope', (RepoItem, $scope) ->
  $scope.items = RepoItem.query()
]).controller('ShowRepoItemsCtrl', ['RepoItem', '$scope', '$routeParams', (RepoItem, $scope, $routeParams) ->
  $scope.current_item = RepoItem.get({id: $routeParams.id}, (current_item)->
    $scope.items = current_item.children
  )
])