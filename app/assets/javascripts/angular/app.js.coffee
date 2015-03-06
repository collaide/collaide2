repoItemsApp = angular.module('repoItemsApp', ['controllers', 'templates', 'ngRoute', 'ngResource', 'ngAnimate', 'angularFileUpload'])

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
      $scope.items[data.id] = data
    , (error) ->
      $scope.folder_error = error.data[0]
    )
  RepoItem.prototype.deleteItem = ($scope, item)->
    console.log(item)
    RepoItem.delete({id: this.id}, (data) ->
      delete $scope.items[item.id]
    , (error) ->
      console.log(error)
    )
  RepoItem.symbol = (item)->
    if item.is_folder
     return 'fi-folder large'
    else
      return 'fi-page large'
  RepoItem.upload = ($scope, files, $upload, current_item_id) =>
    return if files == undefined
    i = 0
    for file in files
      file.id = i
      options = {
        url: '/api/groups/1/repo_items/file.json'
        file: file
      }
      options.fields = {'id': current_item_id} if current_item_id
      file.upload = $upload.upload(options)
      file.upload.progress((event) ->
        file_id = event.config.file.id
        return if $scope.filesUploading[file_id] == undefined
        $scope.filesUploading[file_id].wait = true if event.total == event.loaded
        $scope.filesUploading[file_id].progress = 100 * event.loaded / event.total
      )
      .success((data, status, headers, config) ->
        delete $scope.filesUploading[config.file.id]
        $scope.items[data.id] = new RepoItem(data)
      )
      $scope.filesUploading[i] = file
      i++
  RepoItem.abort = (file, $scope) ->
    $scope.filesUploading[file.id].upload.abort()
    delete $scope.filesUploading[file.id]
  return RepoItem
])

controllers = angular.module('controllers',[])
controllers.controller('IndexRepoItemsCtrl', ['RepoItem', '$scope', '$upload', (RepoItem, $scope, $upload) ->
  $scope.items = {}
  RepoItem.query().$promise.then((items) ->
    for item in items
      $scope.items[item.id] = item
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

]).controller('ShowRepoItemsCtrl', ['RepoItem', '$scope', '$routeParams', '$upload', (RepoItem, $scope, $routeParams, $upload) ->
  $scope.items = {}
  $scope.filesUploading = {}
  $scope.current_item = RepoItem.get({id: $routeParams.id}, (current_item)->
    for item in current_item.children
      $scope.items[item.id] = item
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

  $scope.abort = (file) ->
    RepoItem.abort(file, $scope)
])