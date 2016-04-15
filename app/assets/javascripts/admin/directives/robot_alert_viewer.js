(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotAlertViewer', Directive);

  Directive.$inject = ['RobotSingletonService'];

  function Directive(RobotSingletonService) {
    return {
      template: '<div class="robot-alerts">\
        <div ng-show="!alerts.$resolved" class="robot-alerts-loading">\
          Loading...\
        </div>\
        <div ng-show="alerts.$resolved">\
          <div ng-show="alerts.length == 0" class="robot-alerts-na">\
            No alerts triggered\
          </div>\
          <ul>\
            <li ng-repeat="alert in alerts" title="{{ alert.message }}">\
              <a ng-href="/admin/robots/{{ robotId }}/robot_alerts">{{ alert.title }}</a>\
            </li>\
          </ul>\
        </div>\
      </div>',
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope) {
        _scope.$watch('robotId', function(_id) {
          if(!_id) return;

          var robot = RobotSingletonService.findAndBind(_id, _scope),
              alerts = robot.alerts.$collection({ per_page: 1000 });

          robot.$on('robot-finished', function() { alerts.$refresh(); });

          _scope.alerts = alerts;
        });
      }
    };
  }
})();
