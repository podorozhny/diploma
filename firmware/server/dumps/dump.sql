-- DROP

DROP TABLE IF EXISTS devices CASCADE;
DROP TABLE IF EXISTS entries CASCADE;

-- CREATE

CREATE TABLE devices (
    uuid VARCHAR(36) NOT NULL,
    name VARCHAR(32) NOT NULL,
    PRIMARY KEY(uuid)
);

CREATE UNIQUE INDEX uniq_devices_uuid ON devices (uuid);
CREATE UNIQUE INDEX uniq_devices_name ON devices (name);

CREATE TABLE entries (
    id SERIAL,
    created_at TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    device_uuid VARCHAR(36) NOT NULL,
    geo_point POINT NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX idx_entries_device_uuid ON entries (device_uuid);

ALTER TABLE entries ADD CONSTRAINT fk_entries_device_uuid FOREIGN KEY (device_uuid) REFERENCES devices (uuid) ON UPDATE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

INSERT INTO devices (uuid, name) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', 'test');

INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.772580,37.679060');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.772954,37.678968');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.772980,37.678975');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.773903,37.681157');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.774499,37.683178');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.774663,37.683644');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.773527,37.685078');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.773242,37.686713');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.773187,37.686871');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.770773,37.689944');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.769655,37.691912');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.768720,37.690116');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.767272,37.687681');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.766835,37.687417');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.763953,37.685117');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.761614,37.684467');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.761101,37.684341');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.760857,37.684203');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.760085,37.683274');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759810,37.682683');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759693,37.682362');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759272,37.680385');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759258,37.679919');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759283,37.677607');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759398,37.672231');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759255,37.671749');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.759092,37.671358');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.757308,37.669369');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.757199,37.669345');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.757115,37.669349');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.755121,37.670806');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.754880,37.671197');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.754390,37.672117');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.753605,37.672690');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.753441,37.672698');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.753216,37.672675');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.752154,37.671814');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.751284,37.670479');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.751077,37.670198');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749451,37.667965');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749022,37.667488');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748639,37.666984');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748301,37.666100');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748289,37.665911');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748309,37.665599');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749463,37.663827');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749736,37.663472');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749941,37.663119');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.750369,37.661702');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.750519,37.659969');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.750638,37.658839');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.750385,37.655996');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.750170,37.654910');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749979,37.653657');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748325,37.641389');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748243,37.641161');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748019,37.640755');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749209,37.634363');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749439,37.633452');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749611,37.632490');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749936,37.627144');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749891,37.625918');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749833,37.625044');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.749339,37.620674');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748838,37.617266');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.748678,37.616447');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.747312,37.611127');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.747157,37.610814');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.746950,37.610480');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.743854,37.607433');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.743605,37.607239');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.743420,37.607122');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.742787,37.606840');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.742763,37.606785');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.742746,37.606667');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.744619,37.602803');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.744712,37.602694');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.744354,37.602148');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.739987,37.596599');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.739836,37.596437');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.738426,37.595559');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.736843,37.594901');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.736141,37.594602');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.735540,37.594304');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.732302,37.592253');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.732016,37.592037');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.731819,37.591837');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.731632,37.590869');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.732476,37.589061');
INSERT INTO entries (device_uuid, geo_point) VALUES ('dfedfddd-1de4-4df7-a9b7-021289d2b976', '55.732580,37.588865');
