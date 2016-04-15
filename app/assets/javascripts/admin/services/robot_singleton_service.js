(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('RobotSingletonService', Service);

  Service.$inject = ['Robot', '$interval'];

  function Service(Robot, $interval) {

    var robotCache = {};

    return {
      findAndBind: function(_robotId, _scope) {
        var robotStatus = fetchRobotStatus(_robotId);

        _scope.$on('destroy', function() {
          releaseRobot(robotStatus);
        });

        return robotStatus.robot;
      }
    };

    function fetchRobotStatus(_robotId) {
      var robotStatus = robotCache[_robotId];
      if(!robotStatus) {
        robotStatus = robotCache[_robotId] = setupRobot(_robotId);
      }
      robotStatus.refCount += 1;
      return robotStatus;
    }

    function setupRobot(_robotId) {
      var robot = Robot.$find(_robotId),
          status = {
            robot: robot,
            refCount: 0
          };

      status.interval = $interval(function() {
        robot.$fetch();
      }, 1000);

      return status;
    }

    function releaseRobot(_status) {
      _status.refCount -= 1;
      if(_status.refCount == 0) {
        $interval.cancel(_status.interval);
        delete robotCache[_status.robot.id];
      }
    }
  }
})();
