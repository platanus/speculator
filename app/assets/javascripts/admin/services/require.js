(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('$require', Service);

  Service.$inject = ['$q', '$http'];

  function Service($q, $http) {
    var loaded = {}, head = document.getElementsByTagName('head')[0];

    return function(_url) {
      if(loaded[_url]) return $q.when(true);

      return $http({ method: 'GET', url: _url }).then(function(_response) {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.text = _response.data;
        head.appendChild(script);

        return(loaded[_url] = true);
      });
    };
  }
})();
