require.config();

requirejs(['jquery', 'components/test'], ($, lol) => {
    console.log(lol ? 'application is working!' : 'application is not working!');

    ymaps.ready(() => {
        let $mapElement   = $('#map'),
            centerAndZoom = ymaps.util.bounds.getCenterAndZoom(
                [[55.7, 37.6], [55.8, 37.7]],
                [$mapElement.width(), $mapElement.height()]
            );

        let map = new ymaps.Map($mapElement[0], {
            center:    centerAndZoom.center,
            zoom:      centerAndZoom.zoom + 1,
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

        map.copyrights.add('&copy; Иван Подорожный');

        $.getJSON('/api/v1/device/dfedfddd-1de4-4df7-a9b7-021289d2b976/entries', [], (entries, textStatus) => {
            if (textStatus !== 'success') {
                throw new Error('API error.');
            }

            // dots
            $.each(entries, function (index, entry) {
                map.geoObjects.add(
                    new ymaps.Placemark(
                        [entry.longitude, entry.latitude],
                        {
                            balloonContent: '<pre>' + JSON.stringify(entry, null, 2) + '</pre>'
                        },
                        {
                            iconLayout:      'default#image',
                            iconImageHref:   '/img/black-dot.svg',
                            iconImageSize:   [6, 6],
                            iconImageOffset: [-3, -3]
                        }
                    )
                );
            });

            let coordinates = entries.map((entry) => {
                return [entry.longitude, entry.latitude];
            });

            // polyline
            map.geoObjects.add(new ymaps.Polyline(
                coordinates,
                {
                    hintContent: 'Полилиния, соединяющая координаты'
                },
                {
                    strokeColor:   '#ff0000',
                    strokeOpacity: 0.5,
                    strokeWidth:   6
                }
            ));

            let lastEntry = entries.pop();

            map.setCenter([lastEntry.longitude, lastEntry.latitude], 17);

            // last dot circle
            map.geoObjects.add(
                new ymaps.Circle(
                    [[lastEntry.longitude, lastEntry.latitude], 100],
                    {},
                    {
                        opacity: 0.5
                    }
                )
            );
        });
    });
});
