(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('Robot', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('robots').mix({
      logs: { hasMany: 'RobotLog', path: 'robot_logs' }
    });
  }
})();
