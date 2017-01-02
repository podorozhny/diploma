<?php

require_once __DIR__ . '/../vendor/autoload.php';

$app = new Silex\Application();

$app->get('/', function () use ($app) {
    return 'Hello world!';
});

/** @var \Silex\ControllerCollection $coordinates */
$dashboard = $app['controllers_factory'];

$dashboard->get('/', function () {
    return 'dashboard...';
});

/** @var \Silex\ControllerCollection $coordinates */
$coordinates = $app['controllers_factory'];

$coordinates->get('/', function () {
    return 'all coordinates...';
});

$coordinates->get('/last{count}', function ($count) use ($app) {
    return sprintf('last %d coordinates...', $app->escape($count));
});

$coordinates->post('/', function () {
    return 'new coordinate';
});

$app->mount('/dashboard', $dashboard);

$app->run();
