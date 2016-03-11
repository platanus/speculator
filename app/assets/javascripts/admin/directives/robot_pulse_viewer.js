(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotPulseViewer', Directive);

  Directive.$inject = ['$interval', '$rootScope', 'Robot'];

  function Directive($interval, $rootScope, Robot) {
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
          if(_id) _scope.robot = Robot.$find(_id);
        });

        var isRunning = false;

        $interval(function() {
          if(_scope.robot) {
            _scope.robot.$fetch().$then(function(_robot) {
              if(_robot.isRunning() != isRunning) {
                isRunning = _robot.isRunning();
                $rootScope.$broadcast(isRunning ? 'robot-started' : 'robot-finished', _robot.id)
              }
            });
          }
        }, 1000);
      }
    };
  }
})();
