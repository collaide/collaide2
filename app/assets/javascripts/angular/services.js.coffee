repoItemsService = angular.module('repoItemsService', ['ngResource'])

repoItemsService.factory('RepoItem', ['$resource', ($resource) ->
  $resource('api/groups/1/repo_items/:id.json', {}, {
    query: {method: 'GET', params: {id: 'repo_items'}, isArray: true}
  })
])