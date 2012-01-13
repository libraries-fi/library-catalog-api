--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: add(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION add(integer, integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select $1 + $2;$_$;


--
-- Name: bee(anyarray, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bee(anyarray, text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$select array_to_string(array_agg($1),text($2));$_$;


--
-- Name: cee(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cee(anyelement, anyelement) RETURNS text
    LANGUAGE sql
    AS $_$select array_to_string(array_agg($1),text($2));$_$;


--
-- Name: cee(anyarray, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cee(anyarray, anyelement) RETURNS text
    LANGUAGE sql
    AS $_$select array_to_string(array_agg($1),text($2));$_$;


--
-- Name: concat_delimited(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION concat_delimited(text, text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT $1 || (CASE WHEN $1 = '' THEN '' ELSE $3 END) || $2;
      $_$;


--
-- Name: foo(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION foo(anyelement, anyelement) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select array_to_string(array_agg($1), text($2))$_$;


--
-- Name: string_agg(text, text); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE string_agg(text, text) (
    SFUNC = concat_delimited,
    STYPE = text,
    INITCOND = ''
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE items (
    id integer NOT NULL,
    barcode integer NOT NULL,
    record_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records (
    id integer NOT NULL,
    author_main text,
    isbn character varying(255),
    title_main text,
    helmet_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    marcxml text,
    json text,
    author_indexfield tsvector,
    additional_authors text
);


--
-- Name: records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_id_seq OWNED BY records.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE records ALTER COLUMN id SET DEFAULT nextval('records_id_seq'::regclass);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records
    ADD CONSTRAINT records_pkey PRIMARY KEY (id);


--
-- Name: fii_foo; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fii_foo ON records USING gin (author_indexfield);


--
-- Name: index_items_on_barcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_items_on_barcode ON items USING btree (barcode);


--
-- Name: index_records_on_helmet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_records_on_helmet_id ON records USING btree (helmet_id);


--
-- Name: index_records_on_isbn; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_on_isbn ON records USING btree (isbn);


--
-- Name: records_additional_authors_tindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX records_additional_authors_tindex ON records USING gin (to_tsvector('simple'::regconfig, COALESCE(additional_authors, ''::text)));


--
-- Name: records_author_main_tindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX records_author_main_tindex ON records USING gin (to_tsvector('simple'::regconfig, COALESCE(author_main, ''::text)));


--
-- Name: records_title_main_tindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX records_title_main_tindex ON records USING gin (to_tsvector('simple'::regconfig, COALESCE(title_main, ''::text)));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20110112134749');

INSERT INTO schema_migrations (version) VALUES ('20110221092248');

INSERT INTO schema_migrations (version) VALUES ('20110221092654');

INSERT INTO schema_migrations (version) VALUES ('20110221111806');

INSERT INTO schema_migrations (version) VALUES ('20110222124133');

INSERT INTO schema_migrations (version) VALUES ('20110223082018');

INSERT INTO schema_migrations (version) VALUES ('20110223114439');

INSERT INTO schema_migrations (version) VALUES ('20110223124401');

INSERT INTO schema_migrations (version) VALUES ('20110302084812');

INSERT INTO schema_migrations (version) VALUES ('20110318105810');

INSERT INTO schema_migrations (version) VALUES ('20110328131208');

INSERT INTO schema_migrations (version) VALUES ('20110328132046');

INSERT INTO schema_migrations (version) VALUES ('20110404091803');

INSERT INTO schema_migrations (version) VALUES ('20110404114508');

INSERT INTO schema_migrations (version) VALUES ('20110513143724');

INSERT INTO schema_migrations (version) VALUES ('20110517115648');

INSERT INTO schema_migrations (version) VALUES ('20110518132304');

INSERT INTO schema_migrations (version) VALUES ('20110518132823');

INSERT INTO schema_migrations (version) VALUES ('20110518133855');

INSERT INTO schema_migrations (version) VALUES ('20120112152201');