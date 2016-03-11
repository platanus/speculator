(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotLogViewer', Directive);

  Directive.$inject = ['$interval', 'Robot'];

  function Directive($interval, Robot) {
    return {
      template: '<ul><li ng-repeat="log in logs.slice().reverse()">{{ log.message }}</li></ul>',
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope) {
        _scope.$watch('robotId', function(_id) {
          if(_id) {
            _scope.logs = Robot.$new(_id).logs.$fetch();
          }
        });

        $interval(function() {
          if(_scope.logs) _scope.logs.$refresh();
        }, 1000);
      }
    };
  }
})();
