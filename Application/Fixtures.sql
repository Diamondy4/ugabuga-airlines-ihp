

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.airports DISABLE TRIGGER ALL;

INSERT INTO public.airports (id, name, address) VALUES ('daacaf68-5626-47fb-91f9-58a6ca4e445a', '', '');


ALTER TABLE public.airports ENABLE TRIGGER ALL;


ALTER TABLE public.employees DISABLE TRIGGER ALL;

INSERT INTO public.employees (id, email, password_hash, locked_at, failed_login_attempts, surname, name, passport, airport_id, schedule, accesslevel, salary, jobname) VALUES ('94fc70f7-8485-4417-be97-93eccb98de93', 'diamondy4@hotmail.com', 'sha256|17|q2nt6rhJfxzjsEQk3Kb4gw==|U0S6ODDkqU2vaKFBEd/wYICeRTzWcdSs2cAKIVl8kHM=', NULL, 0, 'Franc', 'Diamondy', '12345 123456', NULL, '', 1, 0, '');


ALTER TABLE public.employees ENABLE TRIGGER ALL;


ALTER TABLE public.dispatchers DISABLE TRIGGER ALL;



ALTER TABLE public.dispatchers ENABLE TRIGGER ALL;


ALTER TABLE public.gates DISABLE TRIGGER ALL;



ALTER TABLE public.gates ENABLE TRIGGER ALL;


ALTER TABLE public.planes DISABLE TRIGGER ALL;



ALTER TABLE public.planes ENABLE TRIGGER ALL;


ALTER TABLE public.flights DISABLE TRIGGER ALL;



ALTER TABLE public.flights ENABLE TRIGGER ALL;


ALTER TABLE public.employeeflight DISABLE TRIGGER ALL;



ALTER TABLE public.employeeflight ENABLE TRIGGER ALL;


