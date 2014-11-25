gulp = require 'gulp'
wiredep = require('wiredep').stream
$ = require('gulp-load-plugins')()

config =
  app: 'app'
  dist: 'dist'

gulp.task 'connect', ->
  $.connect.server
    root: "./#{config.app}"
    livereload: true
    host: "localhost"
    middleware: (connect, opt) ->
      [
        connect.static '.tmp'
        connect().use '/bower_components', connect.static './bower_components'
      ]

gulp.task 'coffee', ->
  gulp.src "./#{config.app}/scripts/*.coffee"
    .pipe $.coffee()
    .pipe gulp.dest '.tmp/scripts'

gulp.task 'watch', ->
  gulp.watch './**/*.*'
    .on 'change', (file) ->
      gulp.src file.path
        .pipe $.connect.reload()

gulp.task 'wiredep', ->
  gulp.src "./#{config.app}/index.html"
    .pipe wiredep
      optional: 'configuration'
      goes: 'here'
    .pipe gulp.dest "./#{config.app}"
