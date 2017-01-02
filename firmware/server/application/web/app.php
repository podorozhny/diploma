<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Silex\Application;
use Silex\ControllerCollection;
use Silex\Provider\TwigServiceProvider;
use Symfony\Component\HttpFoundation\Request;

$app = new Application();

$debug = true;

$app['debug'] = $debug;

$app->before(function (Request $request) {
    if (0 === strpos($request->headers->get('Content-Type'), 'application/json')) {
        $data = json_decode($request->getContent(), true);
        $request->request->replace(is_array($data) ? $data : []);
    }
});

$app->register(new TwigServiceProvider(), [
    'twig.path'    => __DIR__ . '/../app/views',
    'twig.options' => ['debug' => $debug],
]);

$app->get('/', function () use ($app) {
    return $app['twig']->render('pages/dashboard.html.twig');
});

/** @var ControllerCollection $apiVersion1 */
$apiVersion1 = $app['controllers_factory'];

$apiVersion1->get('/coordinates', function () use ($app) {
    return $app->json('coordinates_list', 200);
});

$apiVersion1->get('/coordinates/last/{count}', function () use ($app) {
    return $app->json(sprintf('last_%d_coordinates_list', $app->escape('count')), 200);
});

$apiVersion1->post('/coordinates/{deviceId}', function (Request $request, $deviceId) use ($app) {
    $item = [
        'device_id' => $deviceId,
        'latitude'  => $request->request->get('latitude'),
        'longitude' => $request->request->get('longitude'),
    ];

    $item['created_at'] = (new \DateTime())->format('c');

    return $app->json($item, 201);
});

$app->mount('/api/v1', $apiVersion1);

$app->run();
