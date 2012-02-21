/******************************************************************************/
/***          Generated by IBExpert 2011.10.01 21.02.2012 12:10:04          ***/
/******************************************************************************/

SET SQL DIALECT 3;

SET NAMES UTF8;

CREATE DATABASE 'C:\2bot\2MOONS.FDB'
USER 'SYSDBA' PASSWORD 'masterkey'
PAGE_SIZE 16384
DEFAULT CHARACTER SET UTF8 COLLATION UTF8;



/******************************************************************************/
/***                               Generators                               ***/
/******************************************************************************/

CREATE GENERATOR GEN_PARAMS_ID;
SET GENERATOR GEN_PARAMS_ID TO 33;



SET TERM ^ ; 



/******************************************************************************/
/***                           Stored Procedures                            ***/
/******************************************************************************/

CREATE PROCEDURE DUAL (
    ROWCOUNT INTEGER = 1)
RETURNS (
    ROWID INTEGER)
AS
BEGIN
  SUSPEND;
END^





CREATE PROCEDURE GET_TECH_DEP (
    ID INTEGER)
RETURNS (
    ITEM_ID INTEGER,
    GROUP_ID INTEGER,
    GROUP_NAME VARCHAR(100),
    "LEVEL" INTEGER,
    NAME VARCHAR(100))
AS
BEGIN
  SUSPEND;
END^





CREATE PROCEDURE PLANET_TYPE_TECH_TREE (
    PLANET_TYPE INTEGER)
RETURNS (
    ID INTEGER,
    LVL INTEGER,
    NAME VARCHAR(100),
    GROUP_ID INTEGER,
    GROUP_NAME VARCHAR(100))
AS
BEGIN
  SUSPEND;
END^






SET TERM ; ^



/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/



CREATE TABLE BUILDING_BOOK (
    ID           INTEGER NOT NULL,
    BUILD_LEVEL  INTEGER NOT NULL,
    TAG          INTEGER,
    BUILD_ME     BIGINT,
    BUILD_CRY    BIGINT,
    BUILD_DEI    BIGINT,
    BUILD_TIME   TIMESTAMP,
    LAST_UPDATE  TIMESTAMP
);


CREATE TABLE GAMERS (
    ID           INTEGER NOT NULL,
    NAME         VARCHAR(100),
    ALLIANCE     VARCHAR(100),
    SCORE        BIGINT,
    MAINPL_GAL   INTEGER,
    MAINPL_SYS   INTEGER,
    MAINPL_PL    INTEGER,
    LAST_UPDATE  TIMESTAMP
);


CREATE TABLE GITEM_GROUPS (
    ID    INTEGER NOT NULL,
    NAME  VARCHAR(100)
);


CREATE TABLE GITEMS (
    ID           INTEGER NOT NULL,
    GROUP_ID     INTEGER,
    NAME         VARCHAR(100),
    LAST_UPDATE  TIMESTAMP
);


CREATE TABLE MY_PLANET_TYPES (
    ID    INTEGER NOT NULL,
    NAME  VARCHAR(50)
);


CREATE TABLE MY_PLANETS (
    ID                   INTEGER NOT NULL,
    GALAXY               INTEGER NOT NULL,
    SYSTEM               INTEGER NOT NULL,
    PLANET               INTEGER NOT NULL,
    IS_MOON              SMALLINT,
    NAME                 VARCHAR(50),
    LAST_MACRO_STRATEGY  INTEGER,
    PLANET_BUILD_TYPE    INTEGER,
    SERIAL               INTEGER DEFAULT 0,
    LAST_UPDATE          TIMESTAMP
);


CREATE TABLE PARAMS (
    ID    INTEGER NOT NULL,
    NAME  VARCHAR(100),
    VAL   VARCHAR(1000)
);


CREATE TABLE PLANET_BUILD (
    ID               INTEGER NOT NULL,
    PLANET_TYPE      INTEGER,
    NAME             VARCHAR(100),
    "LEVEL"          INTEGER,
    FORCE_DOWNGRADE  SMALLINT
);


CREATE TABLE SHIP_BOOK (
    ID           INTEGER NOT NULL,
    NAME         VARCHAR(100),
    TAG          VARCHAR(50),
    BUILD_ME     BIGINT,
    BUILD_CRY    BIGINT,
    BUILD_DEI    BIGINT,
    BUILD_TIME   TIMESTAMP,
    LAST_UPDATE  TIMESTAMP
);


CREATE TABLE STRATEGY (
    ID           INTEGER NOT NULL,
    TYPE_ID      INTEGER,
    NAME         VARCHAR(50),
    "ACTIVE"     SMALLINT,
    LAST_UPDATE  TIMESTAMP,
    PARAMS       VARCHAR(1000)
);


CREATE TABLE STRATEGY_TYPES (
    ID    INTEGER NOT NULL,
    NAME  VARCHAR(50)
);


CREATE TABLE TECH_DEPS (
    ITEM_ID      INTEGER NOT NULL,
    DEP_ITEM_ID  INTEGER DEFAULT 0 NOT NULL,
    "LEVEL"      INTEGER DEFAULT 0 NOT NULL,
    LAST_UPDATE  TIMESTAMP
);


CREATE TABLE UNIVERSE (
    GALAXY           INTEGER NOT NULL,
    SYSTEM           INTEGER NOT NULL,
    PLANET           INTEGER NOT NULL,
    NAME             VARCHAR(100),
    HAVE_MOON        SMALLINT,
    HAVE_CRASHFIELD  SMALLINT,
    USER_ID          INTEGER,
    PLANET_ID        INTEGER,
    LAST_UPDATE      TIMESTAMP
);




/******************************************************************************/
/***                              Primary Keys                              ***/
/******************************************************************************/

ALTER TABLE BUILDING_BOOK ADD CONSTRAINT PK_BUILDING_BOOK PRIMARY KEY (ID, BUILD_LEVEL);
ALTER TABLE GAMERS ADD CONSTRAINT PK_GAMERS PRIMARY KEY (ID);
ALTER TABLE GITEMS ADD CONSTRAINT PK_GITEMS PRIMARY KEY (ID);
ALTER TABLE GITEM_GROUPS ADD CONSTRAINT PK_GITEM_GROUPS PRIMARY KEY (ID);
ALTER TABLE MY_PLANETS ADD CONSTRAINT PK_MY_PLANETS PRIMARY KEY (ID);
ALTER TABLE MY_PLANET_TYPES ADD CONSTRAINT PK_MY_PLANET_TYPES PRIMARY KEY (ID);
ALTER TABLE PARAMS ADD CONSTRAINT PK_PARAMS PRIMARY KEY (ID);
ALTER TABLE PLANET_BUILD ADD CONSTRAINT PK_PLANET_BUILD PRIMARY KEY (ID);
ALTER TABLE SHIP_BOOK ADD CONSTRAINT PK_SHIP_BOOK PRIMARY KEY (ID);
ALTER TABLE STRATEGY_TYPES ADD CONSTRAINT PK_STRATEGY_TYPES PRIMARY KEY (ID);
ALTER TABLE TECH_DEPS ADD CONSTRAINT PK_TECH_DEPS PRIMARY KEY (ITEM_ID, DEP_ITEM_ID);
ALTER TABLE UNIVERSE ADD CONSTRAINT PK_UNIVERSE PRIMARY KEY (GALAXY, SYSTEM, PLANET);


/******************************************************************************/
/***                              Foreign Keys                              ***/
/******************************************************************************/

ALTER TABLE GITEMS ADD CONSTRAINT FK_GITEMS_1 FOREIGN KEY (GROUP_ID) REFERENCES GITEM_GROUPS (ID);


/******************************************************************************/
/***                                Indices                                 ***/
/******************************************************************************/

CREATE INDEX STRATEGY_IDX1 ON STRATEGY (ID);


/******************************************************************************/
/***                           Stored Procedures                            ***/
/******************************************************************************/


SET TERM ^ ;

ALTER PROCEDURE DUAL (
    ROWCOUNT INTEGER = 1)
RETURNS (
    ROWID INTEGER)
AS
begin
  ROWID = 1;
  while (ROWID <= ROWCOUNT) do begin
    suspend;
    ROWID = ROWID + 1;
  end
end^


ALTER PROCEDURE GET_TECH_DEP (
    ID INTEGER)
RETURNS (
    ITEM_ID INTEGER,
    GROUP_ID INTEGER,
    GROUP_NAME VARCHAR(100),
    "LEVEL" INTEGER,
    NAME VARCHAR(100))
AS
begin
  for with recursive TREE
      as (select ITEM_ID, DEP_ITEM_ID, level
          from TECH_DEPS
          where ITEM_ID = :ID
          union all
          select B.ITEM_ID, B.DEP_ITEM_ID, B.level
          from TECH_DEPS B, TREE
          where B.ITEM_ID = TREE.DEP_ITEM_ID),
      TREED
      as (select distinct ITEM_ID, DEP_ITEM_ID, level
          from TREE),
      RESTREE
      as (select DEP_ITEM_ID ID, max(level) level
          from TREED
          group by DEP_ITEM_ID)

      select RT.*, GI.GROUP_ID, GG.NAME, GI.NAME
      from RESTREE RT, GITEMS GI, GITEM_GROUPS GG
      where (RT.ID = GI.ID) and
            (GG.ID = GI.GROUP_ID)
      into :ITEM_ID, :level, :GROUP_ID, GROUP_NAME, :NAME
  do
  begin
    suspend;
  end
end^


ALTER PROCEDURE PLANET_TYPE_TECH_TREE (
    PLANET_TYPE INTEGER)
RETURNS (
    ID INTEGER,
    LVL INTEGER,
    NAME VARCHAR(100),
    GROUP_ID INTEGER,
    GROUP_NAME VARCHAR(100))
AS
begin
  for with recursive TREE
      as (select ITEM_ID, DEP_ITEM_ID, "LEVEL"
          from TECH_DEPS
          where ITEM_ID in (select GI.ID
                            from PLANET_BUILD PB, GITEMS GI
                            where (PB.NAME = GI.NAME) and
                                  (PB.PLANET_TYPE = :PLANET_TYPE))
          union all
          select B.ITEM_ID, B.DEP_ITEM_ID, B."LEVEL"
          from TECH_DEPS B, TREE
          where B.ITEM_ID = TREE.DEP_ITEM_ID),
      TREED
      as (select distinct ITEM_ID, DEP_ITEM_ID, "LEVEL"
          from TREE
          union all
          select GI.ID, GI.ID, PB."LEVEL"
          from PLANET_BUILD PB, GITEMS GI
          where (PB.NAME = GI.NAME) and
                (PB.PLANET_TYPE = :PLANET_TYPE)),
      DEPS
      as (select TR.DEP_ITEM_ID ID, max(TR."LEVEL") "LEVEL"
          from TREED TR
          group by TR.DEP_ITEM_ID)
      select DP.*, GI.NAME, GI.GROUP_ID, GG.NAME
      from DEPS DP, GITEMS GI, GITEM_GROUPS GG
      where (DP.ID = GI.ID) and
            (GI.GROUP_ID = GG.ID)
      into :ID, :LVL, :NAME, :GROUP_ID, :GROUP_NAME
  do
    suspend;
end^



SET TERM ; ^
