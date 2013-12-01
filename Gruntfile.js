module.exports = function (grunt) {

  grunt.loadNpmTasks('grunt-mocha-test');

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
    }
  });

  grunt.registerTask('default', 'mochaTest');

};