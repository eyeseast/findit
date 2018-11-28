# A Makefile for making geographies

GEOGRAPHIES = \
	data/massachusetts-towns/massachusetts-towns.topo.json \
	data/massachusetts-towns/massachusetts-towns.mbtiles

.PHONY: all
all: $(GEOGRAPHIES)

# massachusetts towns
tmp/zip/townsurvey_shp.zip:
	mkdir -p $(dir $@)
	curl -o $@ "http://download.massgis.digital.mass.gov/shapefiles/state/townssurvey_shp.zip"
	touch $@

tmp/shp/townsurvey_shp/TOWNSSURVEY_POLY.shp: tmp/zip/townsurvey_shp.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $<

tmp/json/townsurvey_shp/TOWNSSURVEY_POLY.json: tmp/shp/townsurvey_shp/TOWNSSURVEY_POLY.shp
	mkdir -p $(dir $@)
	ogr2ogr -t_srs "EPSG:4326" -f GeoJSON -select "TOWN,TOWN_ID" "$@" "$<"

data/massachusetts-towns/massachusetts-towns.metadata.json:
	mkdir -p $(dir $@)
	echo "{}" > $@

data/massachusetts-towns/massachusetts-towns.topo.json: tmp/json/townsurvey_shp/TOWNSSURVEY_POLY.json data/massachusetts-towns/massachusetts-towns.metadata.json
	mkdir -p $(dir $@)
	npx geo2topo -o $@ $<

data/massachusetts-towns/massachusetts-towns.mbtiles: tmp/json/townsurvey_shp/TOWNSSURVEY_POLY.json
	tippecanoe -o $@ -zg --drop-densest-as-needed $<