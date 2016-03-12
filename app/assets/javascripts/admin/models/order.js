(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('Order', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model(null).mix({
      $config: {
        name: 'order'
      },
      account: { belongsTo: 'Account' }
    });
  }
})();
