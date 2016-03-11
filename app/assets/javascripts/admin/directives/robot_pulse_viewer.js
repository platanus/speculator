(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotPulseViewer', Directive);

  Directive.$inject = ['$interval', 'Robot', 'RobotStatusService'];

  function Directive($interval, Robot, RobotStatusService) {
    return {
      template: '<div class="robot-pulse">\
        <div ng-show="robot.isRunning()" class="robot-status robot-status-running">Running</div>\
        <div ng-show="!robot.isRunning()" class="robot-status robot-status-iddle">Iddle</div>\
        <div ng-show="robot.isEnabled()" class="robot-next-run">{{ robot.nextExecutionAt }}</div>\
        <div ng-show="!robot.isEnabled()" class="robot-next-run">Robot disabled!</div>\
      </div>',
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope) {
        _scope.$watch('robotId', function(_id) {
          if(_id) _scope.robot = updateRobot(Robot.$find(_id));
        });

        $interval(function() {
          if(_scope.robot) updateRobot(_scope.robot)
        }, 1000);

        function updateRobot(_robot) {
          return _robot.$fetch().$then(function(_robot) {
            RobotStatusService.update(_robot);
          });
        }
      }
    };
  }
})();
