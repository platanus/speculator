(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('highcharts', Service);

  Service.$inject = ['$require'];

  function Service($require) {
    return function(_el, _data) {
      // prepare element
      var targetId = _el.attr('id');
      if(targetId == null) {
        targetId = uniqueId();
        _el.attr('id', targetId);
      }

      // prepare data
      if(!_data) _data = {};
      if(!_data.chart) _data.chart = {};
      _data.chart.renderTo = targetId;

      return $require('/assets/highcharts.js').then(function() {
        return new Highcharts.Chart(_data);
      });
    };
  }

  var id = 0;

  function uniqueId() {
    return 'chart-' + id++;
  }
})();
