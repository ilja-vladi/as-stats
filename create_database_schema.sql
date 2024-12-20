CREATE SCHEMA IF NOT EXISTS source;
CREATE SCHEMA IF NOT EXISTS data;

CREATE OR REPLACE FUNCTION data.set_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        NEW.created := CURRENT_TIMESTAMP;
    END IF;
    NEW.updated := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TABLE IF EXISTS data.country;
CREATE TABLE data.country (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    c_id SERIAL PRIMARY KEY,
    c_iso2 VARCHAR(2) NOT NULL,
    c_name VARCHAR(256) NOT NULL
);
CREATE TRIGGER trigger_set_timestamps_country
BEFORE INSERT OR UPDATE ON data.country
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS data.country_tag;
CREATE TABLE data.country_tag (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ct_tag VARCHAR(32) NOT NULL,
    ct_country_id INT NOT NULL,
    PRIMARY KEY (ct_tag, ct_country_id),
    FOREIGN KEY (ct_country_id) REFERENCES data.country(c_id) ON DELETE CASCADE
    );
CREATE TRIGGER trigger_set_timestamps_country_tag
BEFORE INSERT OR UPDATE ON data.country_tag
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS data.asn;
CREATE TABLE data.asn (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    a_id SERIAL PRIMARY KEY,
    a_date TIMESTAMP NOT NULL,
    a_country_iso2 VARCHAR(2) NOT NULL,
    a_ripe_id INTEGER NOT NULL,
    a_is_routed BOOLEAN NOT NULL
);
CREATE TRIGGER trigger_set_timestamps_asn
BEFORE INSERT OR UPDATE ON data.asn
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS data.country_stat;
CREATE TABLE data.country_stat (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cs_id SERIAL PRIMARY KEY,
    cs_country_iso2 VARCHAR(2) NOT NULL,
    cs_stats_timestamp TIMESTAMP NOT NULL,
    cs_stats_resolution VARCHAR(4) NOT NULL,
    cs_v4_prefixes_ris INTEGER,
    cs_v6_prefixes_ris INTEGER,
    cs_asns_ris INTEGER,
    cs_v4_prefixes_stats INTEGER,
    cs_v6_prefixes_stats INTEGER,
    cs_asns_stats INTEGER
);
CREATE TRIGGER trigger_set_timestamps_country_stat
BEFORE INSERT OR UPDATE ON data.country_stat
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS data.country_traffic;
CREATE TABLE data.country_traffic (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cr_id SERIAL PRIMARY KEY,
    cr_country_iso2 VARCHAR(2) NOT NULL,
    cr_date TIMESTAMP NOT NULL,
    cr_traffic NUMERIC NOT NULL
);
CREATE TRIGGER trigger_set_timestamps_country_traffic
BEFORE INSERT OR UPDATE ON data.country_traffic
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS data.country_internet_quality;
CREATE TABLE data.country_internet_quality (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ci_id SERIAL PRIMARY KEY,
    ci_country_iso2 VARCHAR(2) NOT NULL,
    ci_date TIMESTAMP NOT NULL,
    ci_p75 NUMERIC NOT NULL,
    ci_p50 NUMERIC NOT NULL,
    ci_p25 NUMERIC NOT NULL
);
CREATE TRIGGER trigger_set_timestamps_country_internet_quality
BEFORE INSERT OR UPDATE ON data.country_internet_quality
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();

DROP TABLE IF EXISTS data.asn_neighbour;
CREATE TABLE data.asn_neighbour (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    an_asn INTEGER NOT NULL,
    an_neighbour INTEGER NOT NULL,
    an_date TIMESTAMP NOT NULL,
    an_type VARCHAR(32),
    an_power INTEGER NOT NULL,
    an_v4_peers INTEGER,
    an_v6_peers INTEGER,
    CONSTRAINT pk_asn_neighbours PRIMARY KEY (an_asn, an_neighbour, an_type)
);

CREATE TRIGGER trigger_set_timestamps_asn_neighbour
BEFORE INSERT OR UPDATE ON data.asn_neighbour
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();


DROP TABLE IF EXISTS source.api_response;
CREATE TABLE source.api_response (
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ar_id SERIAL PRIMARY KEY,
    ar_url VARCHAR,
    ar_params VARCHAR,
    r_response JSONB
);
CREATE TRIGGER trigger_set_timestamps_api_response
BEFORE INSERT OR UPDATE ON source.api_response
FOR EACH ROW
EXECUTE FUNCTION data.set_timestamps();

