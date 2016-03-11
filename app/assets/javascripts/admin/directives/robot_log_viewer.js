(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotLogViewer', Directive);

  Directive.$inject = ['$interval', 'Robot', 'RobotStatusService'];

  function Directive($interval, Robot, RobotStatusService) {
    return {
      template: '<ul><li ng-repeat="log in logs.slice().reverse()">{{ log.message }}</li></ul>',
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope) {
        var robot = null, lastChance = true;

        _scope.$watch('robotId', function(_id) {
          if(_id) {
            robot = Robot.$new(_id);
            lastChance = true;
            _scope.logs = robot.logs.$fetch();
          }
        });

        $interval(function() {
          if(robot == null) return;

          var isRunning = RobotStatusService.isRunning(robot);
          if(!isRunning && !lastChance) return;

          _scope.logs.$refresh();
          lastChance = isRunning;
        }, 1000);
      }
    };
  }
})();
