(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('robotStatsViewer', Directive);

  Directive.$inject = ['highstock', 'RobotSingletonService'];

  function Directive(highstock, RobotSingletonService) {
    return {
      template: (
        '<div class="robot-stats">\
          <div class="robot-stats-chart"></div>\
        </div>'
      ),
      restrict: 'A',
      scope: {
        robotId: '='
      },
      link: function(_scope, _el) {
        var robot = null,
            chart = null,
            stats = null,
            lastSeries = [];

        function setupChart(_chart) {
          chart = _chart;
        }

        function setupStats(_robot) {
          stats = _robot.stats.$collection({ per_page: 20000, order: 'created_at_asc' });
          stats.$on('after-fetch-many', reloadStats);
        }

        function updateStats() {
          if(!stats) return;
          stats.$refresh();
        }

        function reloadStats() {
          if(!chart) return;
          var series = groupPoints(stats);

          _.each(lastSeries, function(_serie, _name) {
            if(series[_name]) {
              series[_name].serie = _serie.serie;
              _serie.serie.setData(series[_name].points, false);
            } else {
              _serie.serie.remove();
            }
          });

          _.each(series, function(_serie, _name) {
            if(!_serie.serie) {
              _serie.serie = chart.addSeries({ name: _name }, false);
              _serie.serie.setData(series[_name].points, false);
            }
          });

          chart.redraw();
          lastSeries = series;
        }

        function groupPoints(_stats) {
          var groups = {}, group;
          for(var i = 0, l = _stats.length; i < l; i++) {
            group = groups[_stats[i].name];
            if(!group) group = groups[_stats[i].name] = { points: [] };
            group.points.push([_stats[i].createdAt * 1000, _stats[i].value]);
          }
          return groups;
        }

        _scope.$watch('robotId', function(_id) {
          if(!_id) return;

          robot = RobotSingletonService.findAndBind(_id, _scope);
          setupStats(robot);

          robot.$on('robot-finished', updateStats);
          updateStats();
        });

        highstock(_el.find('.robot-stats-chart'), buildChartOptions()).then(function(_chart) {
          setupChart(_chart);
          updateStats();
        });

        function buildChartOptions() {
          return {
            credits: {
              enabled: false
            },
            plotOptions: {
              series: {
                marker: {
                  enabled: true
                }
              }
            },
            rangeSelector: {
              enabled: false
            },
            title: {
              text: null
            },
            xAxis: {
              ordinal: false
            }
          };
        }
      }
    };
  }
})();
