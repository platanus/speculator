(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('RobotAlert', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('robot_alerts');
  }
})();
