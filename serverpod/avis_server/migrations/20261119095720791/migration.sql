BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duel" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "authorId" uuid NOT NULL,
    "authorName" text NOT NULL,
    "question" text NOT NULL,
    "type" text NOT NULL,
    "optionAText" text,
    "optionAUrl" text,
    "optionBText" text,
    "optionBUrl" text
);

-- Indexes
CREATE INDEX "duel_created_at" ON "duel" USING btree ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "username_account" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "username" text NOT NULL,
    "usernameNormalized" text NOT NULL,
    "passwordHash" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "username_account_username_normalized" ON "username_account" USING btree ("usernameNormalized");
CREATE UNIQUE INDEX "username_account_auth_user_id" ON "username_account" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "vote" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "duelId" bigint NOT NULL,
    "userId" uuid NOT NULL,
    "choix" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "vote_duel_user" ON "vote" USING btree ("duelId", "userId");
CREATE INDEX "vote_user" ON "vote" USING btree ("userId");


--
-- MIGRATION VERSION FOR avis
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('avis', '20261119095720791', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261119095720791', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
