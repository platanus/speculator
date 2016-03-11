(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('RobotLog', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('robot_logs');
  }
})();
