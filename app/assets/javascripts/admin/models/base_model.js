(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('BaseModel', Model);

  Model.$inject = [ 'restmod', 'inflector' ];

  function Model(restmod, inflector) {
    return restmod.mixin({
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
          encodeUrlName: inflector.parameterize,
          unpack: function(_resource, _raw) {
            if(_resource.$isCollection) {
              name = this.getProperty('jsonRoot') || this.identity(true);
              return _raw[name];
            } else {
              return _raw;
            }
          }
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
