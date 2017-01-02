require.config();

requirejs(['jquery', 'components/test'], function ($, lol) {
    console.log(lol ? 'application is working!' : 'application is not working!');

    ymaps.ready(() => {
        let $mapElement   = $('#map'),
            centerAndZoom = ymaps.util.bounds.getCenterAndZoom(
                [[55.7, 37.6], [55.8, 37.7]],
                [$mapElement.width(), $mapElement.height()]
            );

        let map = new ymaps.Map($mapElement[0], {
            center:    centerAndZoom.center,
            zoom:      centerAndZoom.zoom,
            behaviors: [
                'default',
                'scrollZoom',
            ],
            controls:  [
                'fullscreenControl',
                'rulerControl',
                'typeSelector',
                'zoomControl',
            ],
        }, {
            suppressMapOpenBlock:            true,
            suppressObsoleteBrowserNotifier: true,
        });

        map.copyrights.add('&copy; Ivan Podorozhny');

        $.getJSON('/api/v1/device/dfedfddd-1de4-4df7-a9b7-021289d2b976/entries', [], function (coordinates, textStatus) {
            if (textStatus !== 'success') {
                throw new Error('API error.');
            }

            coordinates = coordinates.map(function (element) {
                return [element.longitude, element.latitude];
            });

            map.geoObjects.add(new ymaps.Polyline(
                coordinates,
                {
                    hintContent: 'Ломаная линия'
                },
                {
                    strokeColor:   '#ff0000',
                    strokeOpacity: 0.5,
                    strokeWidth:   4
                }
            ));

            $.each(coordinates, function (index, coordinate) {
                map.geoObjects.add(new ymaps.Placemark(coordinate, {}, {
                    iconLayout:      'default#image',
                    iconImageHref:   '/img/dot.svg',
                    iconImageSize:   [4, 4],
                    iconImageOffset: [-2, -2]
                }));
            });
        });
    });
});
