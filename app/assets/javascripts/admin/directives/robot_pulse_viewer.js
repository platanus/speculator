(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotPulseViewer', Directive);

  Directive.$inject = ['RobotSingletonService'];

  function Directive(RobotSingletonService) {
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
          if(!_id) return;
          _scope.robot = RobotSingletonService.findAndBind(_id, _scope);
        });
      }
    };
  }
})();
