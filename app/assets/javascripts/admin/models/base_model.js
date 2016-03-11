(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('BaseModel', Model);

  Model.$inject = [ 'restmod', 'inflector' ];

  function Model(restmod, inflector) {
    return restmod.mixin('DefaultPacker', {
      $config: {
        style: 'ActiveAdmin',
        urlPrefix: '/admin',
        primaryKey: 'id'
      },
      $extend: {
        // special snakecase to camelcase renaming
        Model: {
          decodeName: inflector.camelize,
          encodeName: function(_v) { return inflector.parameterize(_v, '_'); },
          encodeUrlName: inflector.parameterize
        }
      },
      $hooks: {
        'before-request': function(_request) {
          _request.url += '.json'; // say whaaat
        }
      }
    });
  }
})();
