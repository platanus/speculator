(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('accountViewer', Directive);

  Directive.$inject = ['$interval', 'highcharts', 'Account'];

  function Directive($interval, highcharts, Account) {
    return {
      template: (
        '<div class="account-widget">\
          <div class="account-details">\
            <div class="account-name"><a href="{{ account.$url() }}">{{ account.name }}</a></div>\
            <div class="account-exchange">{{ account.exchange }}</div>\
            <div class="account-market">{{ account.baseCurrency }}\\{{ account.quoteCurrency }}</div>\
          </div>\
          <div class="account-order-chart"></div>\
        </div>'
      ),
      restrict: 'A',
      scope: {
        accountId: '='
      },
      link: function(_scope, _el) {
        _scope.$watch('accountId', function(_id) {
          if(_id) {
            _scope.account = Account.$find(_id);
            _scope.orders = _scope.account.orders.$search({ scope: 'open' });
          }
        });

        highcharts(_el.find('.account-order-chart'), buildChartOptions()).then(function(_chart) {
          var bids = _chart.addSeries({ color: 'green', name: 'Bid' }, false),
              asks = _chart.addSeries({ color: 'red', name: 'Ask' }, false);

          function updateSeries() {
            if(_scope.account == null) return;

            // _scope.account.$fetch();
            _scope.orders.$refresh().$then(function(_orders) {
              bids.setData(extractPoints(_orders, 'bid'));
              asks.setData(extractPoints(_orders, 'ask'));
            });
          }

          updateSeries();
          $interval(updateSeries, 30000);
        });

        function buildChartOptions() {
          return {
            credits: {
              enabled: false
            },
            chart: {
              type: 'column',
              panning: false,
              style: {
                fontFamily: '"Segoe UI","Helvetica Neue",Helvetica,Arial,sans-serif'
              }
            },
            plotOptions: {
              column: {
                grouping: false,
                pointPadding: 0.1,
                groupPadding: 0.0
              },
              series: {
                marker: {
                  enabled: true
                }
              }
            },
            title: {
              text: null
            },
            legend: {
              enabled: false
            },
            xAxis: {
              type: 'linear',
              title: {
                text: null
              }
            },
            yAxis: {
              type: 'linear',
              floor: 0,
              title: {
                text: null
              }
            }
          };
        }

        function extractPoints(_orders, _instruction) {
          var mult = _instruction == 'bid' ? -1 : 1,
              accum = 0.0;

          return _.chain(_orders)
                  .filter(function(o) { return o.instruction == _instruction; })
                  .sortBy(function(o) { return mult * o.price; })
                  .map(function(o) { accum += o.volume; return [o.price, accum]; })
                  .value();
        }
      }
    };
  }
})();
