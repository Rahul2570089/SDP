--
-- Class Investor as table investors
--

CREATE TABLE "investors" (
  "id" serial,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "password" text NOT NULL
);

ALTER TABLE ONLY "investors"
  ADD CONSTRAINT investors_pkey PRIMARY KEY (id);


--
-- Class StartUp as table startups
--

CREATE TABLE "startups" (
  "id" serial,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "password" text NOT NULL
);

ALTER TABLE ONLY "startups"
  ADD CONSTRAINT startups_pkey PRIMARY KEY (id);


