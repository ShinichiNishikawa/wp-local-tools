var gulp         = require("gulp");
var sass         = require("gulp-sass");
var sourcemaps   = require('gulp-sourcemaps');
var autoprefixer = require("gulp-autoprefixer");
var browserSync  = require("browser-sync").create();
var plumber      = require("gulp-plumber");

gulp.task('serve', ['sass'], function() {

    browserSync.init({
        proxy: "example.loc"
    });

    gulp.watch("sass/*.scss",["sass"]).on('change', browserSync.reload);
    gulp.watch("js/*.js"             ).on('change', browserSync.reload);
    gulp.watch("*.php"               ).on('change', browserSync.reload);
    gulp.watch("*/**/*.php"          ).on('change', browserSync.reload);

});

gulp.task("sass", function() {
    gulp.src("sass/style.scss")
        .pipe(plumber())
        .pipe(sourcemaps.init())
        .pipe(sass())
        .pipe(autoprefixer())
        .pipe(sourcemaps.write("./sass/maps"))
        .pipe(gulp.dest("./css"))
        .pipe(browserSync.reload({stream:true}));
});

gulp.task("default", ['serve']);
