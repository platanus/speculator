angular.module('ActiveAdmin', ['restmod']).config(['restmodProvider', function(restmod) {
  restmod.rebase('BaseModel');
}]);
