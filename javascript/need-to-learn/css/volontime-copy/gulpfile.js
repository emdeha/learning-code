var gulp = require('gulp')
var ejs = require('gulp-ejs')

gulp.task('build', function () {
  return gulp.src('./templates/body.ejs')
    .pipe(ejs())
    .on('error', console.log)
    .pipe(gulp.dest('dest'))
})

gulp.task('default', ['build'])
