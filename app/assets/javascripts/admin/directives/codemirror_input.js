(function() {
  'use strict';

  angular
    .module('ActiveAdmin')
    .directive('codemirrorInput', Directive);

  Directive.$inject = ['$compile'];

  var TEMPLATE = ('\
        <div class="codemirror-input">\
          <div codemirror-editor ng-model="code" mode="{{ mode }}" theme="{{ theme }}"></div>\
          <input type="hidden" name="{{ name }}"></input>\
        </div>\
      ');

  function Directive($compile) {
    return {
      restrict: 'EA',
      scope: {
        name: '@',
        mode: '@',
        theme: '@'
      },
      link: function(_scope, _el, _attrs) {
        _scope.code = JSON.parse(_el.text()) || "";
        _el.empty();
        _el.append($compile(TEMPLATE)(_scope));

        var hidden = _el.find('input');
        _scope.$watch('code', function(_value) {
          hidden.val(_value);
        });
      }
    };
  }
})();
