repoItemsApp = angular.module('repoItemsApp', ['controllers', 'templates', 'ngRoute', 'ngResource'])

repoItemsApp.config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/repo_items', {
    templateUrl: 'repo_items.html'
    controller: 'IndexRepoItemsCtrl'
  }).when('/repo_items/:id', {
    templateUrl: 'repo_items.html'
    controller: 'ShowRepoItemsCtrl'
  })
  .otherwise({redirectTo: '/repo_items'})
  $locationProvider.html5Mode(true);
)
repoItemsApp.factory('RepoItem', ['$resource', ($resource) ->
  RepoItem = $resource('/api/groups/1/repo_items/:id:action_type.json', {action_type: ''}, {
    query: {method: 'GET', params: {id: ''}, isArray: true}
    createFolder: {
      method: 'POST', params: {id: '', action_type: 'folder'}
    }
  })
  RepoItem.prototype.addFolder = ($scope) ->
    this.repo_folder.name = '' if this.repo_folder.name == undefined
    this.$createFolder((data) ->
      $scope.items.unshift(data)
    , (error) ->
      console.log(error)
    )
  return RepoItem
])

controllers = angular.module('controllers',[])
controllers.controller('IndexRepoItemsCtrl', ['RepoItem', '$scope', (RepoItem, $scope) ->
  $scope.items = RepoItem.query()
  $scope.createFolder = (folder_name) ->
    new RepoItem({repo_folder: {name: folder_name}}).addFolder($scope)
]).controller('ShowRepoItemsCtrl', ['RepoItem', '$scope', '$routeParams', (RepoItem, $scope, $routeParams) ->
  $scope.current_item = RepoItem.get({id: $routeParams.id}, (current_item)->
    $scope.items = current_item.children
  )
  $scope.createFolder = (folder_name, current_folder) ->
    new RepoItem({repo_folder: {id: current_folder.id, name: folder_name}}).addFolder($scope)
])