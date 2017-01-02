<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Doctrine\DBAL\Connection;
use Silex\Application;
use Silex\ControllerCollection;
use Silex\Provider\DoctrineServiceProvider;
use Silex\Provider\TwigServiceProvider;
use Symfony\Component\HttpFoundation\Request;

$app = new Application();

$app['debug'] = true;

$app->register(new DoctrineServiceProvider(), [
    'db.options' => [
        'driver'   => 'pdo_pgsql',
        'host'     => 'database',
        'dbname'   => 'bot_db',
        'user'     => 'bot',
        'password' => 'bot',
        'charset'  => 'utf8',
    ],
]);

/** @var Connection $db */
$db = &$app['db'];

$app->register(new TwigServiceProvider(), [
    'twig.path'    => __DIR__ . '/../app/views',
    'twig.options' => ['debug' => $app['debug']],
]);

$app->before(function (Request $request) {
    if (0 === strpos($request->headers->get('Content-Type'), 'application/json')) {
        $data = json_decode($request->getContent(), true);
        $request->request->replace(is_array($data) ? $data : []);
    }
});

$app->get('/', function () use ($app) {
    return $app['twig']->render('pages/dashboard.html.twig');
});

/** @var ControllerCollection $apiVersion1 */
$apiVersion1 = $app['controllers_factory'];

$apiVersion1->get('/coordinates', function () use ($app) {
    return $app->json('coordinates_list', 200);
});

$apiVersion1->get('/coordinates/last/{count}', function ($count) use ($app) {
    return $app->json(sprintf('last_%d_coordinates_list', $count), 200);
});

$apiVersion1->post('/coordinates/{deviceId}', function (Request $request, $deviceId) use ($app, $db) {
    $device = $db->fetchAssoc('SELECT * FROM posts WHERE id = :id', ['id' => (int) $deviceId]);

    var_dump($device);
    die();

//    $item = [
//        'device_id' => $deviceId,
//        'latitude'  => $request->request->get('latitude'),
//        'longitude' => $request->request->get('longitude'),
//    ];
//
    $item['created_at'] = (new \DateTime())->format('c');

    return $app->json($item, 201);
});

$app->mount('/api/v1', $apiVersion1);

$app->run();
