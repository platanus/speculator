(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotLogViewer', Directive);

  Directive.$inject = ['RobotSingletonService'];

  function Directive(RobotSingletonService) {
    return {
      template: (
        '<div class="robot-log">\
          <ul>\
            <li ng-repeat="log in logs.slice().reverse()" class="{{ \'level-\' + log.level }}">{{ log.message }}</li>\
          </ul>\
        </div>'
      ),
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope) {
        _scope.$watch('robotId', function(_id) {
          if(!_id) return;
          var robot = RobotSingletonService.findAndBind(_id, _scope),
              logs = robot.logs.$search({ per_page: 1000 });

          robot.$on('robot-started', function() { logs.$clear(); })
          robot.$on('robot-running', function() { logs.$refresh(); })
          robot.$on('robot-finished', function() { logs.$refresh(); })

          _scope.logs = logs;
        });
      }
    };
  }
})();
