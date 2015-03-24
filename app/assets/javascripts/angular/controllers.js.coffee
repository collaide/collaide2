controllers = angular.module('controllers',['repoItemsService'])
controllers.controller('IndexRepoItemsCtrl', ['RepoItem', '$scope', '$upload', 'Collaide', (RepoItem, $scope, $upload, Collaide) ->
  $scope.items = {}
  $scope.filesUploading = {}
  $scope.visible = false

  RepoItem.query().$promise.then((items) ->
    for item in items
      $scope.items[item.id] = item
      $scope.items[item.id].download_path = Collaide.download_path(item)
    Collaide.hide_loading($scope)
  )

  $scope.createFolder = (folder_name) ->
    new RepoItem({repo_folder: {name: folder_name}}).addFolder($scope)

  $scope.delete = (item) ->
    item.deleteItem($scope, item)

  $scope.item_symbol = (item) ->
    return RepoItem.symbol(item)

  $scope.$watch('files', () ->
    $scope.upload($scope.files)
  )

  $scope.closeAlertBox = (item) ->
    item.error = undefined

  $scope.empty = (items) ->
    angular.equals(items, {})

  $scope.upload = (files) ->
    RepoItem.upload($scope, files, $upload)

  $scope.abort = (file) ->
    RepoItem.abort(file, $scope)

  $scope.removeDownload = (key) ->
    delete $scope.filesUploading[key]

  $scope.deleteAll = () ->
    angular.forEach($scope.items, (item) ->
      item.deleteItem($scope, item) if item.checked || $scope.checked
    )

]).controller('ShowRepoItemsCtrl', ['RepoItem', '$scope', '$routeParams', '$upload', 'Collaide', (RepoItem, $scope, $routeParams, $upload, Collaide) ->
  $scope.items = {}
  $scope.filesUploading = {}
  $scope.visible = false

  $scope.current_item = RepoItem.get({id: $routeParams.id}, (current_item)->
    $scope.current_item.download_path = Collaide.download_path(current_item)
    $scope.current_item.content = {}
    if parseInt(current_item.file_size) > 1000000 and current_item.is_text
      $scope.current_item.content.status = 'too_big'
    else if current_item.is_text
      RepoItem.viewContent(current_item.id).success((data) ->
        Collaide.hide_loading($scope)
        $scope.current_item.content.data = data
      ).error((data, status) ->
        Collaide.hide_loading($scope)
        $scope.current_item.content.data = data
        $scope.current_item.content.status = 'error'
        $scope.current_item.content.error = status
      )
    for item in current_item.children
      $scope.items[item.id] = item
      $scope.items[item.id].download_path = Collaide.download_path(item)
    Collaide.hide_loading($scope)
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

  $scope.closeAlertBox = (item) ->
    item.error = undefined

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
  $scope.removeDownload = (key) ->
    delete $scope.filesUploading[key]
])