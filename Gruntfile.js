module.exports = function (grunt) {
  grunt.initConfig({
    // Configure a mochaTest task
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: ['coffee-script', 'sinon-chai', './test/bootstrap.coffee']
        },
        src: ['test/**/*.spec.coffee']
      }
    },

    watch: {
      files: ['src/**/*.coffee', 'test/**/*.coffee'],
      tasks: ['test']
    }
  });

  //load modules
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-contrib-watch');

  //task registers
  grunt.registerTask('test', 'mochaTest');
  grunt.registerTask('default', 'mochaTest');
};