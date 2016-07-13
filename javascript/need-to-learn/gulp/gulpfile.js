var gulp = require('gulp')
var jshint = require('gulp-jshint')
var sass = require('gulp-sass')
var sourcemaps = require('gulp-sourcemaps')
var gutil = require('gulp-util')
var concat = require('gulp-concat')
var uglify = require('gulp-uglify')

gulp.task('default', ['watch'])

gulp.task('jshint', function () {
  return gulp.src('source/javascript/**/*.js')
    .pipe(jshint())
    .pipe(jshint.reporter('jshint-stylish'))
})

gulp.task('build-js', ['jshint'], function () {
  return gulp.src('source/javascript/**/*.js')
    .pipe(sourcemaps.init())
    .pipe(concat('bundle.js'))
    .pipe(gulp.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('public/assets/javascript'))
})

gulp.task('build-css', function () {
  return gulp.src('source/scss/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('public/assets/stylesheets'))
})

gulp.task('watch', function () {
  gulp.watch('source/javascript/**/*.js', ['jshint', 'build-js'])
  gulp.watch('source/scss/**/*.scss', ['build-css'])
})
