(function(undefined) {
  'use strict';

  angular
    .module('ActiveAdmin')
    .factory('Robot', Model);

  Model.$inject = [ 'restmod' ];

  function Model(restmod) {
    return restmod.model('robots').mix({
      logs: { hasMany: 'RobotLog', path: 'robot_logs' },
      alerts: { hasMany: 'RobotAlert', path: 'robot_alerts' },
      stats: { hasMany: 'RobotStat', path: 'robot_stats' },

      isRunning: function() {
        return this.startedAt != null;
      },
      isEnabled: function() {
        return this.nextExecutionAt != null;
      },

      $hooks: {
        'after-feed': function(_raw) {
          var running = this.isRunning();

          if(this.$wasRunning === undefined || this.$wasRunning != running) {
            this.$dispatch(running ? 'robot-started' : 'robot-finished');
          }

          if(running) {
            this.$dispatch('robot-running');
          }

          this.$wasRunning = running;
        }
      }
    });
  }
})();
