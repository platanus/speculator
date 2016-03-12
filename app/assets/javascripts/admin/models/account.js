(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('Account', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('accounts').mix({
      orders: { hasMany: 'Order' }
    });
  }
})();
