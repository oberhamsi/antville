#------------------------------
# Table structure for AV_ACCESSLOG
#------------------------------
create table AV_ACCESSLOG (
   ACCESSLOG_ID int(10) default UNIQUEKEY('AV_ACCESSLOG') not null,
   ACCESSLOG_F_SITE int(10),
   ACCESSLOG_F_TEXT int(10),
   ACCESSLOG_REFERRER text,
   ACCESSLOG_IP varchar(20),
   ACCESSLOG_BROWSER varchar(255),
   ACCESSLOG_DATE timestamp default DATEOB(),
   primary key (ACCESSLOG_ID)
);

#---------------------------
# Indexes on table AV_ACCESSLOG
#---------------------------

create index IDX_ACCESSLOG_F_SITE on AV_ACCESSLOG (ACCESSLOG_F_SITE);
create index IDX_ACCESSLOG_F_TEXT on AV_ACCESSLOG (ACCESSLOG_F_TEXT);
create index IDX_ACCESSLOG_DATE on AV_ACCESSLOG (ACCESSLOG_DATE);

#----------------------------
# Table structure for AV_CHOICE
#----------------------------

create table AV_CHOICE (
   CHOICE_ID int(10) not null,
   CHOICE_F_POLL int(10),
   CHOICE_TITLE varchar(255),
   CHOICE_CREATETIME timestamp,
   CHOICE_MODIFYTIME timestamp,
   primary key (CHOICE_ID)
);

#----------------------------
# Indexes on table AV_CHOICE
#----------------------------

CREATE INDEX IDX_CHOICE_F_POLL ON AV_CHOICE (CHOICE_F_POLL);

#----------------------------
# Table structure for AV_FILE
#----------------------------
create table AV_FILE (
  FILE_ID int(10) not null,
  FILE_F_SITE int(10),
  FILE_ALIAS varchar(128),
  FILE_MIMETYPE varchar(128),
  FILE_NAME varchar(128),
  FILE_SIZE int(10),
  FILE_DESCRIPTION text,
  FILE_REQUESTCNT int(10),
  FILE_CREATETIME timestamp,
  FILE_F_USER_CREATOR int(10),
  FILE_MODIFYTIME timestamp,
  FILE_F_USER_MODIFIER int(10),
  primary key (FILE_ID)
);

#----------------------------
# Indexes on table AV_FILE
#----------------------------

CREATE INDEX IDX_FILE_F_SITE ON AV_FILE (FILE_F_SITE);
CREATE INDEX IDX_FILE_ALIAS ON AV_FILE (FILE_ALIAS);
CREATE INDEX IDX_FILE_F_USER_CREATOR ON AV_FILE (FILE_F_USER_CREATOR);

#----------------------------
# Table structure for AV_IMAGE
#----------------------------
create table AV_IMAGE (
   IMAGE_ID int(10) not null,
   IMAGE_F_SITE int(10),
   IMAGE_F_IMAGE_PARENT int(10),
   IMAGE_F_IMAGE_THUMB int(10),
   IMAGE_ALIAS varchar(128),
   IMAGE_FILENAME varchar(128),
   IMAGE_FILEEXT varchar(128),
   IMAGE_WIDTH int(4),
   IMAGE_HEIGHT int(4),
   IMAGE_ALTTEXT varchar(128),
   IMAGE_CREATETIME timestamp,
   IMAGE_F_USER_CREATOR int(10),
   IMAGE_MODIFYTIME timestamp,
   IMAGE_F_USER_MODIFIER int(10),
   primary key (IMAGE_ID)
);

#----------------------------
# Indexes on table AV_IMAGE
#----------------------------

CREATE INDEX IDX_IMAGE_F_SITE ON AV_IMAGE (IMAGE_F_SITE);
CREATE INDEX IDX_IMAGE_ALIAS ON AV_IMAGE (IMAGE_ALIAS);
CREATE INDEX IDX_IMAGE_F_IMAGE_PARENT ON AV_IMAGE (IMAGE_F_IMAGE_PARENT);
CREATE INDEX IDX_IMAGE_F_IMAGE_THUMB ON AV_IMAGE (IMAGE_F_IMAGE_THUMB);
CREATE INDEX IDX_IMAGE_F_USER_CREATOR ON AV_IMAGE (IMAGE_F_USER_CREATOR);

#----------------------------
# records for table AV_IMAGE
#----------------------------
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (1,'big','big','gif',404,53,'antville.org');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (2,'smallanim','smallanim','gif',98,30,'made with antville');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (3,'smallchaos','smallchaos','gif',107,29,'made with antville');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (4,'smallstraight','smallstraight','gif',107,24,'made with antville');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (5,'pixel','pixel','gif',1,1,'pixel');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT) values (6,'headbg','headbg','gif',3,52);
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (7,'menu','menu','gif',36,13,'menu');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (8,'recent','recent','gif',123,13,'recently modified');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (9,'status','status','gif',48,13,'status');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (10,'dot','dot','gif',30,30,'dots');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (11,'bullet','bullet','gif',3,10,'bullet');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (12,'webloghead','webloghead','gif',404,53,'head');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (13,'hop','hop','gif',124,25,'helma object publisher');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (14,'xmlbutton','xmlbutton','gif',36,14,'XML button');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (15,'marquee','marquee','gif',15,15,'marquee');
insert into AV_IMAGE (IMAGE_ID,IMAGE_ALIAS,IMAGE_FILENAME,IMAGE_FILEEXT,IMAGE_WIDTH,IMAGE_HEIGHT,IMAGE_ALTTEXT) values (16,'manage','manage','gif',50,13,'manage');

#-------------------------------
# Table structure for AV_MEMBERSHIP
#-------------------------------
create table AV_MEMBERSHIP (
   MEMBERSHIP_ID int(10) not null,
   MEMBERSHIP_F_SITE int(10),
   MEMBERSHIP_F_USER int(10),
   MEMBERSHIP_USERNAME varchar(128),
   MEMBERSHIP_LEVEL int(10),
   MEMBERSHIP_CREATETIME timestamp,
   MEMBERSHIP_MODIFYTIME timestamp,
   MEMBERSHIP_F_USER_MODIFIER int(10),
   primary key (MEMBERSHIP_ID)
);

#----------------------------
# Indexes on table AV_MEMBERSHIP
#----------------------------

CREATE INDEX IDX_MEMBERSHIP_F_SITE ON AV_MEMBERSHIP (MEMBERSHIP_F_SITE);
CREATE INDEX IDX_MEMBERSHIP_F_USER ON AV_MEMBERSHIP (MEMBERSHIP_F_USER);
CREATE INDEX IDX_MEMBERSHIP_USERNAME ON AV_MEMBERSHIP (MEMBERSHIP_USERNAME);
CREATE INDEX IDX_MEMBERSHIP_LEVEL ON AV_MEMBERSHIP (MEMBERSHIP_LEVEL);

#----------------------------
# Table structure for AV_POLL
#----------------------------

create table AV_POLL (
   POLL_ID int(10) not null,
   POLL_F_SITE int(10),
   POLL_TITLE varchar(255),
   POLL_QUESTION text,
   POLL_ISONLINE tinyint(1),
   POLL_CLOSED tinyint(4),
   POLL_CLOSETIME timestamp,
   POLL_CREATETIME timestamp,
   POLL_F_USER_CREATOR int(10),
   POLL_MODIFYTIME timestamp,
   POLL_F_USER_MODIFIER int(10),
   primary key (POLL_ID)
);

#----------------------------
# Indexes on table AV_POLL
#----------------------------

CREATE INDEX IDX_POLL_F_SITE ON AV_POLL (POLL_F_SITE);
CREATE INDEX IDX_POLL_F_USER_CREATOR ON AV_POLL (POLL_F_USER_CREATOR);

#----------------------------
# Table structure for AV_SKIN
#----------------------------
create table AV_SKIN (
   SKIN_ID int(10) not null,
   SKIN_F_SITE int(10),
   SKIN_PROTOTYPE varchar(128),
   SKIN_NAME varchar(128),
   SKIN_SOURCE text,
   SKIN_CREATETIME timestamp,
   SKIN_F_USER_CREATOR int(10),
   SKIN_MODIFYTIME timestamp,
   SKIN_F_USER_MODIFIER int(10),
   primary key (SKIN_ID)
);

#----------------------------
# Indexes on table AV_SKIN
#----------------------------

CREATE INDEX IDX_SKIN_F_SITE ON AV_SKIN (SKIN_F_SITE);
CREATE INDEX IDX_SKIN_PROTOTYPE ON AV_SKIN (SKIN_PROTOTYPE);
CREATE INDEX IDX_SKIN_NAME ON AV_SKIN (SKIN_NAME);

#----------------------------
# Table structure for AV_SYSLOG
#----------------------------

create table AV_SYSLOG (
  SYSLOG_ID int(10) not null,
  SYSLOG_TYPE varchar(128) null,
  SYSLOG_OBJECT varchar(128) null,
  SYSLOG_ENTRY text null,
  SYSLOG_CREATETIME timestamp null,
  SYSLOG_F_USER_CREATOR int(10) null,
  primary key (SYSLOG_ID)
);

CREATE INDEX IDX_SYSLOG_TYPE ON AV_SYSLOG (SYSLOG_TYPE);
CREATE INDEX IDX_SYSLOG_OBJECT ON AV_SYSLOG (SYSLOG_OBJECT);

#----------------------------
# Table structure for AV_TEXT
#----------------------------

create table AV_TEXT (
   TEXT_ID int(10) not null,
   TEXT_F_SITE int(10),
   TEXT_DAY varchar(10),
   TEXT_TOPIC varchar(255),
   TEXT_PROTOTYPE varchar(20),
   TEXT_F_TEXT_STORY int(10),
   TEXT_F_TEXT_PARENT int(10),
   TEXT_ALIAS varchar(255),
   TEXT_TITLE text,
   TEXT_TEXT text,
   TEXT_CONTENT text,
   TEXT_RAWCONTENT text,
   TEXT_ISONLINE tinyint(1),
   TEXT_EDITABLEBY tinyint(1),
   TEXT_HASDISCUSSIONS tinyint(1),
   TEXT_CREATETIME timestamp,
   TEXT_F_USER_CREATOR int(10),
   TEXT_MODIFYTIME timestamp,
   TEXT_F_USER_MODIFIER int(10),
   TEXT_READS int(10),
   TEXT_IPADDRESS varchar(20),
   primary key (TEXT_ID)
);

#----------------------------
# Indexes on table AV_TEXT
#----------------------------

CREATE INDEX IDX_TEXT_F_SITE ON AV_TEXT (TEXT_F_SITE);
CREATE INDEX IDX_TEXT_TOPIC ON AV_TEXT (TEXT_TOPIC);
CREATE INDEX IDX_TEXT_DAY ON AV_TEXT (TEXT_DAY);
CREATE INDEX IDX_TEXT_PROTOTYPE ON AV_TEXT (TEXT_PROTOTYPE);
CREATE INDEX IDX_TEXT_F_TEXT_STORY ON AV_TEXT (TEXT_F_TEXT_STORY);
CREATE INDEX IDX_TEXT_F_TEXT_PARENT ON AV_TEXT (TEXT_F_TEXT_PARENT);
CREATE INDEX IDX_TEXT_ISONLINE ON AV_TEXT (TEXT_ISONLINE);
CREATE INDEX IDX_TEXT_F_USER_CREATOR ON AV_TEXT (TEXT_F_USER_CREATOR);

#----------------------------
# Table structure for AV_USER
#----------------------------

create table AV_USER (
   USER_ID int(10) not null,
   USER_NAME varchar(128),
   USER_PASSWORD varchar(128),
   USER_EMAIL varchar(128),
   USER_EMAIL_ISPUBLIC tinyint(1),
   USER_URL varchar(128),
   USER_REGISTERED timestamp,
   USER_LASTVISIT timestamp,
   USER_ISBLOCKED tinyint(1),
   USER_ISTRUSTED tinyint(1),
   USER_ISSYSADMIN tinyint(1),
   primary key (USER_ID)
);

#----------------------------
# Indexes on table AV_USER
#----------------------------

CREATE INDEX IDX_USER_NAME ON AV_USER (USER_NAME);
CREATE INDEX IDX_USER_PASSWORD ON AV_USER (USER_PASSWORD);
CREATE INDEX IDX_USER_ISBLOCKED ON AV_USER (USER_ISBLOCKED);
CREATE INDEX IDX_USER_ISTRUSTED ON AV_USER (USER_ISTRUSTED);
CREATE INDEX IDX_USER_ISSYSADMIN ON AV_USER (USER_ISSYSADMIN);

#----------------------------
# Table structure for AV_VOTE
#----------------------------

create table AV_VOTE (
   VOTE_ID int(10) not null,
   VOTE_F_POLL int(10),
   VOTE_F_USER int(10),
   VOTE_F_CHOICE int(10),
   VOTE_USERNAME varchar(128),
   VOTE_CREATETIME timestamp,
   VOTE_MODIFYTIME timestamp,
   primary key (VOTE_ID)
);

#----------------------------
# Indexes on table AV_VOTE
#----------------------------

CREATE INDEX IDX_VOTE_F_POLL ON AV_VOTE (VOTE_F_POLL);
CREATE INDEX IDX_VOTE_F_USER ON AV_VOTE (VOTE_F_USER);
CREATE INDEX IDX_VOTE_F_CHOICE ON AV_VOTE (VOTE_F_CHOICE);
CREATE INDEX IDX_VOTE_USERNAME ON AV_VOTE (VOTE_USERNAME);

#----------------------------
# Table structure for AV_SITE
#----------------------------
create table AV_SITE (
   SITE_ID int(10) not null,
   SITE_TITLE varchar(128),
   SITE_ALIAS varchar(128),
   SITE_TAGLINE varchar(128),
   SITE_EMAIL varchar(128),
   SITE_BGCOLOR varchar(6),
   SITE_TEXTFONT varchar(128),
   SITE_TEXTCOLOR varchar(6),
   SITE_TEXTSIZE varchar(4),
   SITE_LINKCOLOR varchar(6),
   SITE_ALINKCOLOR varchar(6),
   SITE_VLINKCOLOR varchar(6),
   SITE_TITLEFONT varchar(128),
   SITE_TITLECOLOR varchar(6),
   SITE_TITLESIZE varchar(4),
   SITE_SMALLFONT varchar(128),
   SITE_SMALLCOLOR varchar(6),
   SITE_SMALLSIZE varchar(4),
   SITE_ISONLINE tinyint(1),
   SITE_ISBLOCKED tinyint(1),
   SITE_ISTRUSTED tinyint(1),
   SITE_LASTUPDATE timestamp,
   SITE_LASTOFFLINE timestamp,
   SITE_LASTBLOCKWARN timestamp,
   SITE_LASTDELWARN timestamp,
   SITE_LASTPING timestamp,
   SITE_ENABLEPING tinyint(1),
   SITE_HASDISCUSSIONS tinyint(1),
   SITE_USERMAYCONTRIB tinyint(1),
   SITE_SHOWDAYS tinyint(4),
   SITE_SHOWARCHIVE tinyint(1),
   SITE_LANGUAGE varchar(2),
   SITE_COUNTRY varchar(2),
   SITE_TIMEZONE varchar(32),
   SITE_LONGDATEFORMAT varchar(50),
   SITE_SHORTDATEFORMAT varchar(50),
   SITE_CREATETIME timestamp,
   SITE_F_USER_CREATOR int(10),
   SITE_MODIFYTIME timestamp,
   SITE_F_USER_MODIFIER int(10),
   primary key (SITE_ID)
);

#----------------------------
# Indexes on table AV_SITE
#----------------------------

CREATE INDEX IDX_SITE_ALIAS ON AV_SITE (SITE_ALIAS);
CREATE INDEX IDX_SITE_ISONLINE ON AV_SITE (SITE_ISONLINE);
CREATE INDEX IDX_SITE_ISBLOCKED ON AV_SITE (SITE_ISBLOCKED);
CREATE INDEX IDX_SITE_ENABLEPING ON AV_SITE (SITE_ENABLEPING);
CREATE INDEX IDX_SITE_LASTPING ON AV_SITE (SITE_LASTPING);
CREATE INDEX IDX_SITE_F_USER_CREATOR ON AV_SITE (SITE_F_USER_CREATOR);
