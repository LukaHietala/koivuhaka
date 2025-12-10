PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "asunnot" (
	"id"	INTEGER,
	"osoite"	TEXT NOT NULL,
	"kuva"	TEXT NOT NULL,
	"hinta"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO asunnot VALUES(1,'Punaketunkatu 4 I, Koivuhaka, Kokkola','https://cdn.asunnot.oikotie.fi/Ih_sUqa6ojLgDQT96F-4-gGIyws=/full-fit-in/980x653/filters:watermark(https://cdn.asunnot.oikotie.fi/FNgYc0cxRts1I9PguvqoW4Bqtrw=/static.asunnot.oikotie.fi/oikotie_watermark.png,0,-1,1):background_color(white):format(jpeg)/ot-real-estate-mediabank-prod/540/160/source/225061045',65000);
INSERT INTO asunnot VALUES(7,'Mäyränkatu 5, 55, Koivuhaka, Kokkola','https://cdn.asunnot.oikotie.fi/OVSKC8aSElH0mLOqs9XKtBH5wWg=/filters:watermark(https://cdn.asunnot.oikotie.fi/FNgYc0cxRts1I9PguvqoW4Bqtrw=/static.asunnot.oikotie.fi/oikotie_watermark.png,0,-1,1)/ot-real-estate-mediabank-prod/980/741/source/225147089',59000);
INSERT INTO asunnot VALUES(8,'Punaketunkatu 4 B, Koivuhaka, Kokkola','https://cdn.asunnot.oikotie.fi/s5oMh1riaTM8h1CfxKEsjvP-n_o=/filters:watermark(https://cdn.asunnot.oikotie.fi/FNgYc0cxRts1I9PguvqoW4Bqtrw=/static.asunnot.oikotie.fi/oikotie_watermark.png,0,-1,1)/ot-real-estate-mediabank-prod/995/480/source/225084599',59000);
INSERT INTO asunnot VALUES(9,'Mäntynäädänkatu 8, Koivuhaka, Kokkola','https://cdn.asunnot.oikotie.fi/hJU-1_6rzXHvLDh03mSYGS9YbaE=/full-fit-in/980x550/filters:watermark(https://cdn.asunnot.oikotie.fi/FNgYc0cxRts1I9PguvqoW4Bqtrw=/static.asunnot.oikotie.fi/oikotie_watermark.png,0,-1,1):background_color(white):format(jpeg)/ot-real-estate-mediabank-prod/157/220/source/225022751',45000);
INSERT INTO asunnot VALUES(19,'Oravankatu 16 tal, Koivuhaka, Kokkola','http://localhost:8080/static/images/n02112018_4583.jpg',100000);
CREATE TABLE IF NOT EXISTS "kayttajat" (
	"id"	INTEGER,
	"nimi"	TEXT,
	"salasana_hash"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO kayttajat VALUES(1,'admin','$2b$10$xpW1l4GAPlT4AogncTVaT.tKZvm/jpRSsJ0DZMmikewnpdKfPVOuC');
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('asunnot',19);
INSERT INTO sqlite_sequence VALUES('kayttajat',1);
COMMIT;
