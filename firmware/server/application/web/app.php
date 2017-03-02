<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Types\Type;
use Podorozhny\Doctrine\GeoPointType;
use Silex\Application;
use Silex\ControllerCollection;
use Silex\Provider\DoctrineServiceProvider;
use Silex\Provider\TwigServiceProvider;
use Symfony\Component\Debug\ErrorHandler;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\OptionsResolver\Exception\InvalidArgumentException;
use Symfony\Component\OptionsResolver\OptionsResolver;

$app = new Application();

$app['debug'] = true;

$app->register(
    new DoctrineServiceProvider(),
    [
        'db.options' => [
            'driver'   => 'pdo_pgsql',
            'host'     => 'database',
            'dbname'   => 'dbname',
            'user'     => 'dbuser',
            'password' => 'dbpass',
            'charset'  => 'utf8',
        ],
    ]
);

/** @var Connection $db */
$db = &$app['db'];

Type::addType('geo_point', GeoPointType::class);
$db->getDatabasePlatform()->registerDoctrineTypeMapping('GetPointType', 'geo_point');

$app->register(
    new TwigServiceProvider(),
    [
        'twig.path'    => __DIR__ . '/../app/views',
        'twig.options' => ['debug' => $app['debug']],
    ]
);

$app->before(
    function (Request $request) {
        if (0 === strpos($request->headers->get('Content-Type'), 'application/json')) {
            $data = json_decode($request->getContent(), true);
            $request->request->replace(is_array($data) ? $data : []);
        }
    }
);

ErrorHandler::register();
$app->error(
    function (\Exception $e, $code) use ($app) {
        $error = ['message' => $e->getMessage()];

        if ($e instanceof BadRequestHttpException) {
            $code = Response::HTTP_BAD_REQUEST;
        } elseif ($e instanceof NotFoundHttpException) {
            $code = Response::HTTP_NOT_FOUND;
        } elseif ($code < 400) {
            $code = Response::HTTP_INTERNAL_SERVER_ERROR;
        }

        return $app->json($error, $code);
    }
);

$app->get(
    '/',
    function () use ($app) {
        return $app['twig']->render('pages/map.html.twig');
    }
);

/** @var ControllerCollection $apiVersion1 */
$apiVersion1 = $app['controllers_factory'];

$apiVersion1->get(
    '/device/{deviceUuid}/entries',
    function ($deviceUuid) use ($app, $db) {
        $device = $db->fetchAssoc('SELECT * FROM devices WHERE uuid = :uuid', ['uuid' => $deviceUuid]);

        if (!$device) {
            throw new NotFoundHttpException(sprintf('No device with UUID "%s" found.', $deviceUuid));
        }

        $entries = $db->fetchAll(
            'SELECT
            id,
            created_at,
            device_uuid,
            geo_point[0]::FLOAT AS longitude,
            geo_point[1]::FLOAT AS latitude
        FROM entries
        WHERE device_uuid = :device_uuid',
            ['device_uuid' => $deviceUuid]
        );

        foreach ($entries as &$entry) {
            $entry['longitude'] = (float) $entry['longitude'];
            $entry['latitude']  = (float) $entry['latitude'];
        }

        return $app->json($entries, 200);
    }
);

$apiVersion1->post(
    '/device/{deviceUuid}/entries',
    function (Request $request, $deviceUuid) use ($app, $db) {
        $device = $db->fetchAssoc('SELECT * FROM devices WHERE uuid = :uuid', ['uuid' => $deviceUuid]);

        if (!$device) {
            throw new NotFoundHttpException(sprintf('No device with UUID "%s" found.', $deviceUuid));
        }

        $resolver = new OptionsResolver();
        $resolver->setRequired(['latitude', 'longitude']);
        $resolver->setAllowedTypes('latitude', 'float');
        $resolver->setAllowedTypes('longitude', 'float');

        try {
            $options = $resolver->resolve($request->request->all());
        } catch (InvalidArgumentException $e) {
            throw new BadRequestHttpException($e->getMessage());
        }

        $result = $db->insert(
            'entries',
            [
                'device_uuid' => $deviceUuid,
                'geo_point'   => sprintf('%s,%s', $options['latitude'], $options['longitude']),
            ]
        );

        if (!$result) {
            throw new \RuntimeException('Error while inserting new entry.');
        }

        $entry = $db->fetchAssoc(
            'SELECT
            id,
            created_at,
            device_uuid,
            geo_point[0]::FLOAT AS longitude,
            geo_point[1]::FLOAT AS latitude
        FROM entries
        WHERE id = :id',
            ['id' => (int) $db->lastInsertId()]
        );

        $entry['longitude'] = (float) $entry['longitude'];
        $entry['latitude']  = (float) $entry['latitude'];

        return $app->json($entry, 201);
    }
);

$apiVersion1->get(
    '/device/{deviceUuid}/entries/create-random',
    function ($deviceUuid) use ($app, $db) {
        $device = $db->fetchAssoc('SELECT * FROM devices WHERE uuid = :uuid', ['uuid' => $deviceUuid]);

        if (!$device) {
            throw new NotFoundHttpException(sprintf('No device with UUID "%s" found.', $deviceUuid));
        }

        $maximumError = [0.00025, 0.0007];

        $latitude  = 55.766791;
        $longitude = 37.686183;

        $latitude += round(mt_rand(-$maximumError[0] * 10000000, $maximumError[0] * 10000000) / 10000000, 6);
        $longitude += round(mt_rand(-$maximumError[1] * 10000000, $maximumError[1] * 10000000) / 10000000, 6);

        $result = $db->insert(
            'entries',
            [
                'device_uuid' => $deviceUuid,
                'geo_point'   => sprintf('%s,%s', $latitude, $longitude),
            ]
        );

        if (!$result) {
            throw new \RuntimeException('Error while inserting new entry.');
        }

        $entry = $db->fetchAssoc(
            'SELECT
            id,
            created_at,
            device_uuid,
            geo_point[0]::FLOAT AS longitude,
            geo_point[1]::FLOAT AS latitude
        FROM entries
        WHERE id = :id',
            ['id' => (int) $db->lastInsertId()]
        );

        $entry['longitude'] = (float) $entry['longitude'];
        $entry['latitude']  = (float) $entry['latitude'];

        return $app->json($entry, 201);
    }
);

$app->mount('/api/v1', $apiVersion1);

$app->run();
