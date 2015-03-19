repoItemsApp = angular.module('repoItemsApp', ['controllers', 'templates', 'ngRoute', 'ngAnimate', 'angularFileUpload'])

repoItemsApp.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when('/repo_items', {
    templateUrl: 'repo_items.html'
    controller: 'IndexRepoItemsCtrl'
  }).when('/repo_items/:id', {
    templateUrl: 'repo_items.html'
    controller: 'ShowRepoItemsCtrl'
  }).otherwise({redirectTo: '/repo_items'})
  $locationProvider.html5Mode(true);
])
repoItemsApp.factory('Collaide', () ->
  {
    api_path: (path) ->
      "/api/groups/#{$('base').attr('group_id')}/" + path
  }
)

controllers = angular.module('controllers',['repoItemsService'])
controllers.controller('IndexRepoItemsCtrl', ['RepoItem', '$scope', '$upload', 'Collaide', (RepoItem, $scope, $upload, Collaide) ->
  $scope.items = {}
  RepoItem.query().$promise.then((items) ->
    for item in items
      $scope.items[item.id] = item
      $scope.items[item.id].download_path = Collaide.api_path("repo_items/#{item.id}/download.json")
  )

  $scope.filesUploading = {}

  $scope.createFolder = (folder_name) ->
    new RepoItem({repo_folder: {name: folder_name}}).addFolder($scope)

  $scope.delete = (item) ->
    item.deleteItem($scope, item)

  $scope.item_symbol = (item) ->
    return RepoItem.symbol(item)

  $scope.$watch('files', () ->
    $scope.upload($scope.files)
  )

  $scope.empty = (items) ->
    angular.equals(items, {})

  $scope.upload = (files) ->
    RepoItem.upload($scope, files, $upload)

  $scope.abort = (file) ->
    RepoItem.abort(file, $scope)

  $scope.deleteAll = () ->
      angular.forEach($scope.items, (item) ->
        item.deleteItem($scope, item) if item.checked || $scope.checked
      )

]).controller('ShowRepoItemsCtrl', ['RepoItem', '$scope', '$routeParams', '$upload', 'Collaide', (RepoItem, $scope, $routeParams, $upload, Collaide) ->
  $scope.items = {}
  $scope.filesUploading = {}
  $scope.current_item = RepoItem.get({id: $routeParams.id}, (current_item)->
    $scope.current_item.download_path = Collaide.api_path("repo_items/#{current_item.id}/download.json")
    if current_item.is_text
      RepoItem.viewContent(current_item.id).success((data) ->
        $scope.current_item.content = data
      ).error((data) ->
        $scope.current_item.content = data
      )
    for item in current_item.children
      $scope.items[item.id] = item
      $scope.items[item.id].download_path = Collaide.api_path("repo_items/#{item.id}/download.json")
  )
  $scope.createFolder = (folder_name, current_folder) ->
    new RepoItem({repo_folder: {id: current_folder.id, name: folder_name}}).addFolder($scope)

  $scope.delete = (item) ->
    new RepoItem({id: item.id}).deleteItem($scope, item)

  $scope.item_symbol = (item) ->
    return RepoItem.symbol(item)

  $scope.$watch('files', () ->
    $scope.upload($scope.files, $scope.current_item)
  )

  $scope.empty = (items) ->
    angular.equals(items, {})

  $scope.upload = (files, current_item) ->
    RepoItem.upload($scope, files, $upload, current_item.id)

  $scope.deleteAll = () ->
    angular.forEach($scope.items, (item) ->
      new RepoItem({id: item.id}).deleteItem($scope, item) if item.checked || $scope.checked
    )
  $scope.print_type = (item) ->
    switch item.content_type
      when 'text/plain' then 'Fichier texte'
      when 'image/jpeg' then 'Image JPEG'
      else 'Inconnu'

  $scope.abort = (file) ->
    RepoItem.abort(file, $scope)
]).controller('DetailRepoItemCtrl', ['RepoItem', '$scope', '$routeParams', '$upload', (RepoItem, $scope, $routeParams, $upload) ->
  $scope.current_item = RepoItem.get({id:$routeParams.id})

])