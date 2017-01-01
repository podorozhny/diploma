'use strict';

let env    = process.env.NODE_ENV || 'dev';
let isProd = env === 'prod';

let config = require('./gulp-config.json');

let browserSync      = require('browser-sync');
let del              = require('del');
let eventStream      = require('event-stream');
let gulp             = require('gulp');
let gulpAmdOptimize  = require('gulp-amd-optimize');
let gulpAutoprefixer = require('gulp-autoprefixer');
let gulpBabel        = require('gulp-babel');
let gulpCleanCss     = require('gulp-clean-css');
let gulpConcat       = require('gulp-concat');
let gulpFilter       = require('gulp-filter');
let gulpIf           = require('gulp-if');
let gulpNewer        = require('gulp-newer');
let gulpNotify       = require('gulp-notify');
let gulpOrder        = require('gulp-order');
let gulpPlumber      = require('gulp-plumber');
let gulpPug          = require('gulp-pug');
let gulpSass         = require('gulp-sass');
let gulpUglify       = require('gulp-uglify');
let gulpWrapper      = require('gulp-wrapper');
let path             = require('path');
let runSequence      = require('run-sequence');
let when             = require('when');

gulp.task('default', function (callback) {
    runSequence(
        'build',
        callback
    );
});

gulp.task('clean', function (callback) {
    runSequence(
        [
            'clean-fonts',
            'clean-img',
            'clean-tpl',
            'clean-css',
            'clean-js',
        ],
        callback
    );
});

gulp.task('build', function (callback) {
    runSequence(
        ['fonts', 'img', 'tpl', 'css', 'js'],
        callback
    );
});

gulp.task('watch', function () {
    browserSync.init({
        server: 'web',
        online: false,
        open:   false,
        notify: false
    });

    // TODO: не реагирует на новые файлы

    gulp.watch(config.watch.tpl, ['tpl']);
    gulp.watch(config.watch.img, ['img']);
    gulp.watch(config.watch.fonts, ['fonts']);
    gulp.watch(config.watch.css, ['css']);
    gulp.watch(config.watch.js, ['js']);
});

gulp.task('fonts', ['clean-fonts'], function () {
    let streams = [];

    Object.keys(config.build.src.fonts).forEach(function (key) {
        let sources = [key + '/**'];

        let dest = config.build.dest.fonts + config.build.src.fonts[key];

        streams.push(
            gulp.src(sources)
                .pipe(gulpNewer(dest))
                .pipe(gulp.dest(dest))
                .pipe(browserSync.stream())
        );
    });

    return eventStream.merge(streams);
});

gulp.task('clean-fonts', function () {
    return del(config.clean.fonts);
});

gulp.task('img', ['clean-img'], function () {
    return gulp.src(config.build.src.img)
        .pipe(gulpNewer(config.build.dest.img))
        .pipe(gulp.dest(config.build.dest.img))
        .pipe(browserSync.stream());
});

gulp.task('clean-img', function () {
    return del(config.clean.img);
});

gulp.task('tpl', ['clean-tpl'], function () {
    let streams = [];

    Object.keys(config.build.src.tpl).forEach(function (key) {
        let destination = config.build.dest.tpl + config.build.src.tpl[key];

        streams.push(
            gulp.src(key)
                .pipe(gulpIf(
                    !isProd,
                    gulpPlumber({
                        errorHandler: function (error) {
                            gulpNotify.onError({
                                title:   'Compile error',
                                message: '<%= error.toString() %>',
                                sound:   'Beep'
                            }).apply(this, arguments);

                            // TODO: останавливать таск здесь
                        }
                    })
                ))
                .pipe(gulpPug({
                    pretty: !isProd
                }))
                .pipe(gulp.dest(destination))
                .pipe(browserSync.stream())
        );
    });

    return eventStream.merge(streams);
});

gulp.task('clean-tpl', function () {
    return del(config.clean.tpl);
});

gulp.task('css', ['clean-css'], function () {
    return css();
});

gulp.task('js', ['clean-js'], function () {
    return js();
});

function css() {
    let currentPathLength = path.resolve(__dirname).length;

    const filterSass = gulpFilter(['**/*.sass', '**/*.scss'], { restore: true });

    let sources = config.build.src.css,
        order   = [];

    Object.keys(sources).forEach(function (key) {
        order.push(sources[key].replace('.scss', '.css').replace('.sass', '.css'));
    });

    return gulp.src(sources)
        .pipe(gulpIf(
            !isProd,
            gulpPlumber({
                errorHandler: function (error) {
                    gulpNotify.onError({
                        title:   'Compile error',
                        message: '<%= error.toString() %>',
                        sound:   'Beep'
                    }).apply(this, arguments);

                    // TODO: останавливать таск здесь
                }
            })
        ))
        .pipe(filterSass)
        .pipe(gulpSass())
        .pipe(filterSass.restore)
        .pipe(gulpAutoprefixer({
            browsers: ['last 2 versions']
        }))
        .pipe(gulpIf(
            isProd,
            gulpCleanCss({
                compatibility:       'ie8',
                keepSpecialComments: false
            }),
            gulpWrapper({
                header: function (file) {
                    return '/* ########## Beginning of ' + file.path.substr(currentPathLength) + ' ########## */\n\n';
                },
                footer: function (file) {
                    return '\n\n/* ########## End of ' + file.path.substr(currentPathLength) + ' ########## */\n\n';
                }
            })
        ))
        .pipe(gulpOrder(order, { base: './' }))
        .pipe(gulpConcat((function () {
            let filename = 'app';

            if (!isProd) {
                filename += '-' + env;
            }

            return filename + '.css';
        })()))
        .pipe(gulp.dest(config.build.dest.css))
        .pipe(browserSync.stream());
}

function js() {
    // TODO: sourcemaps

    const currentPathLength = path.resolve(__dirname).length;

    const filterRequirejs = gulpFilter(
        ['**', '!node_modules/requirejs/require.js'],
        { restore: true }
    );

    const filterVendor = gulpFilter(
        ['**', '!node_modules/**'],
        { restore: true }
    );

    return gulp.src(config.build.src.js)
        .pipe(gulpIf(
            !isProd,
            gulpPlumber({
                errorHandler: function (error) {
                    gulpNotify.onError({
                        title:   'Compile error',
                        message: '<%= error.toString() %>',
                        sound:   'Beep'
                    }).apply(this, arguments);

                    // TODO: останавливать таск здесь
                }
            })
        ))
        .pipe(filterVendor)
        .pipe(gulpBabel({
            presets: ['es2015']
        }))
        .pipe(filterVendor.restore)
        .pipe(gulpIf(
            isProd,
            gulpUglify(),
            gulpWrapper({
                header: function (file) {
                    return '/* ########## Beginning of ' + file.path.substr(currentPathLength) + ' ########## */\n\n';
                },
                footer: function (file) {
                    return '\n\n/* ########## End of ' + file.path.substr(currentPathLength) + ' ########## */\n\n';
                }
            })
        ))
        .pipe(filterRequirejs)
        .pipe(gulpAmdOptimize('config'))
        .pipe(filterRequirejs.restore)
        .pipe(gulpConcat((function () {
            let filename = 'app';

            if (!isProd) {
                filename += '-' + env;
            }

            return filename + '.js';
        })()))
        .pipe(gulp.dest(config.build.dest.js))
        .pipe(browserSync.stream());
}
