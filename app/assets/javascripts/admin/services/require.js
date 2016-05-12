(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('$require', Service);

  Service.$inject = ['$q', '$http', '$timeout'];

  function Service($q, $http, $timeout) {
    var loaded = {}, head = document.getElementsByTagName('head')[0];

    return function() {
      var urls = Array.prototype.slice.call(arguments);
      if(angular.isArray(urls[0])) {
        urls = urls[0].slice();
      }

      return load_recursive(urls);
    };

    function load_recursive(_urls) {
      if(_urls.length === 0) return;

      var url = _urls.shift();
      if(!loaded[url]) loaded[url] = request_resource(url);
      return loaded[url].then(function() {
        return load_recursive(_urls);
      });
    }

    function request_resource(_url) {
      return $http({ method: 'GET', url: _url }).then(function(_response) {
        switch(_url.substr(-3,3)) {
        case '.js':
          var script = document.createElement('script');
          script.type = 'text/javascript';
          script.text = _response.data;
          head.appendChild(script);
          break;
        case 'css':
          var style = document.createElement('style');
          style.type = 'text/css';
          if (style.styleSheet){
            style.styleSheet.cssText = _response.data;
          } else {
            style.appendChild(document.createTextNode(_response.data));
          }
          head.appendChild(style);
          break;
        }
      });
    }
  }
})();
