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
    host: "192.168.1.18"
    middleware: (connect, opt) ->
      [
        connect.static '.tmp'
        connect().use '/bower_components', connect.static './bower_components'
      ]

gulp.task 'connect:dist', ->
  $.connect.server
    root: "./#{config.dist}"

gulp.task 'watch', ->
  gulp.watch './**/*.*'
    .on 'change', (file) ->
      gulp.src file.path
        .pipe $.connect.reload()

gulp.task 'coffee', ->
  gulp.src "./#{config.app}/scripts/*.coffee"
    .pipe $.coffee()
    .pipe gulp.dest '.tmp/scripts'

gulp.task 'wiredep', ->
  gulp.src "#{config.app}/index.html"
    .pipe wiredep
      ignorePath: '../'
    .pipe gulp.dest "./#{config.app}"

gulp.task 'serve', ['connect', 'watch']

gulp.task 'copy:dist', ->
  gulp.src ['{,*/}*.html', '{,*/}*.js'], cwd: "#{config.app}"
    .pipe gulp.dest '.tmp/'

  gulp.src ['./bower_components/**/*.*'], base: './'
    .pipe gulp.dest '.tmp/'

gulp.task 'vulcanize', ['copy:dist'], ->
  gulp.src ".tmp/index.html"
    .pipe $.vulcanize
      dest: "#{config.dist}"
      strip: true
      inline: true
      csp: true
    .pipe gulp.dest "#{config.dist}"
