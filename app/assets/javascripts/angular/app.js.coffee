repoItemsApp = angular.module('repoItemsApp', ['controllers', 'templates', 'ngRoute', 'ngAnimate', 'angularFileUpload', 'angularSpinner'])

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
    download_path: (item) ->
      this.api_path("repo_items/#{item.id}/download.json")
    hide_loading: ($scope) ->
      $('#folder-loading').remove()
      $scope.visible = true
  }
)