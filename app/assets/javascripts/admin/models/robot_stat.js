(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('RobotStat', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('robot_stats');
  }
})();
