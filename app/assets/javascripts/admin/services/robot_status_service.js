(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('RobotStatusService', Service);

  Service.$inject = [];

  function Service() {

    var globalStatus = {};

    return {
      update: function(_robot) {
        globalStatus[_robot.$pk] = _robot.isRunning() ? 'running' : 'stopped';
      },
      isRunning: function(_robot) {
        return (globalStatus[_robot.$pk] || 'running') == 'running';
      }
    }
  }
})();
