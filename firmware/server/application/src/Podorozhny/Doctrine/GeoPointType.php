<?php

namespace Podorozhny\Doctrine;

use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\Type;
use Podorozhny\GeoPoint;

/**
 * Class GeoPointType
 * @package Podorozhny\Doctrine
 */
class GeoPointType extends Type
{
    const GEO_POINT = 'geo_point';

    /**
     * @inheritdoc
     */
    public function getSQLDeclaration(array $fieldDeclaration, AbstractPlatform $platform)
    {
        return 'POINT';
    }

    /**
     * @inheritdoc
     */
    public function convertToPHPValue($value, AbstractPlatform $platform)
    {
        return new GeoPoint($value[0], $value[1]);
    }

    /**
     * @inheritdoc
     */
    public function convertToDatabaseValue($geoPoint, AbstractPlatform $platform)
    {
        /** @var GeoPoint $geoPoint */
        return $geoPoint->getLongitude() . ',' . $geoPoint->getLatitude();
    }

    /**
     * @inheritdoc
     */
    public function getName()
    {
        return self::GEO_POINT;
    }
}