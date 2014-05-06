path = require("path")
send = require("send")
targetDev = "target/dev"
targetProd = "target/prod"

mountFolder = (connect, dir) ->
  connect.static path.resolve(dir)

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      dev:
        expand: true
        cwd: "src/coffee"
        src: ["**/*.coffee"]
        dest: "#{targetDev}/js"
        ext: ".js"
      prod:
        expand: true
        cwd: "src/coffee"
        src: ["**/*.coffee"]
        dest: "#{targetProd}/js"
        ext: ".js"

    uglify:
      prod:
        expand: true
        cwd: "#{targetProd}/js"
        src: ["**/*.js"]
        dest: "#{targetProd}/js"

    jade:
      dev:
        files: [
          expand: true
          cwd: "src/jade"
          src: "**/*.jade"
          dest: "#{targetDev}"
          ext: ".html"
        ]
        options:
          pretty: true

      prod:
        files: [
          expand: true
          cwd: "src/jade"
          src: "**/*.jade"
          dest: "#{targetProd}"
          ext: ".html"
        ]
        options:
          pretty: false

    less:
      dev:
        files: [
          src: "src/less/main.less"
          dest: "#{targetDev}/css/main.css"
        ]
      prod:
        files: [
          src: "src/less/main.less"
          dest: "#{targetProd}/css/main.css"
        ]
        options:
          cleancss: true
      options:
        paths: ["src/less"]
        cleancss: false

    copy:
      dev:
        files: [
          expand: true
          cwd: "src/resources"
          src: "**/*.*"
          dest: "#{targetDev}"
        ]
      prod:
        files: [
          expand: true
          cwd: "src/resources"
          src: "**/*.*"
          dest: "#{targetProd}"
        ,
          expand: true
          cwd: "bower_components"
          src: "**/*.*"
          dest: "#{targetProd}/bower_components"
        ]

    connect:
      dev:
        options:
          port: 9000
          hostname: "0.0.0.0"
          middleware: (connect) ->
            [ mountFolder(connect, "#{targetDev}/"), mountFolder(connect, "") ]

    watch:
      options:
        livereload: true

      coffee:
        files: ["src/coffee/**/*.coffee"]
        tasks: ["coffee:dev"]

      jade:
        files: ["src/jade/**/*.jade"]
        tasks: ["jade:dev"]

      less:
        files: ["src/less/**/*.less"]
        tasks: ["less:dev"]

      resources:
        files: ["src/resources/**/*.*"]
        tasks: ["copy:dev"]

    clean:
      options: { force: true }
      dev: ["#{targetDev}/"]
      prod: ["#{targetProd}/"]

  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
  grunt.registerTask "dev-build", ["clean:dev", "coffee:dev", "jade:dev", "less:dev", "copy:dev"]
  grunt.registerTask "prod-build", ["clean:prod", "coffee:prod", "uglify:prod", "jade:prod", "less:prod", "copy:prod"]
  grunt.registerTask "dev-server", ["dev-build", "connect:dev"]
  grunt.registerTask "default", ["dev-server", "watch"]
