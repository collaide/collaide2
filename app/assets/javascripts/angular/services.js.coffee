repoItemsService = angular.module('repoItemsService', ['ngResource', 'angularFileUpload'])

.factory('RepoItem', ['$resource', 'Collaide', '$http', ($resource, Collaide, $http) ->
    RepoItem = $resource(Collaide.api_path('repo_items/:id:action_type.json'), {action_type: ''}, {
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
          url: Collaide.api_path('repo_items/file.json')
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

    RepoItem.viewContent = (id) ->
      $http.get(Collaide.api_path("repo_items/#{id}/download.json"))

    return RepoItem
  ])