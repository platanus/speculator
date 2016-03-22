(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('highstock', Service);

  Service.$inject = ['highcharts'];

  function Service(highcharts) {
    return function(_el, _data) {
      return highcharts(_el, _data, 'StockChart');
    };
  }
})();
