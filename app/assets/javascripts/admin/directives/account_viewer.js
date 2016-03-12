(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('accountViewer', Directive);

  Directive.$inject = ['$interval', 'Account'];

  function Directive($interval, Account) {
    return {
      template: (
        '<div>\
          <div><a href="{{ account.$url() }}">{{ account.name }}</a></div>\
          <div>{{ account.exchange }}</div>\
          <div>{{ account.baseCurrency }}\\{{ account.quoteCurrency }}</div>\
          <div>\
            <ul>\
              <li ng-repeat="order in orders">{{ order.price }}</li>\
            </ul>\
          </div>\
        </div>'
      ),
      restrict: 'A',
      scope: {
        accountId: '='
      },
      link: function(_scope) {
        _scope.$watch('accountId', function(_id) {
          if(_id) {
            _scope.account = Account.$find(_id);
            _scope.orders = _scope.account.orders.$search({ scope: 'open' });
          }
        });

        $interval(function() {
          if(_scope.account == null) return;

          // _scope.account.$fetch();
          _scope.orders.$refresh();
        }, 10000);
      }
    };
  }
})();
