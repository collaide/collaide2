repoItemsApp = angular.module('repoItemsApp', [])

repoItemsApp.controller('RepoItemsController', ($scope, $http) ->
  $http.get($('#controller').attr('api-path')).success((data) ->
    $scope.items = data
  )
)