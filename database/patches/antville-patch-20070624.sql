use antville;

alter table AV_IMAGE add column IMAGE_PARENT_PROTOTYPE mediumint(10) default NULL;

update AV_IMAGE set IMAGE_PARENT_PROTOTYPE = 'Site' where IMAGE_PROTOTYPE = 'Image';
update AV_IMAGE set IMAGE_PARENT_PROTOTYPE = 'Layout' where IMAGE_PROTOTYPE = 'LayoutImage';
update AV_IMAGE set IMAGE_PROTOTYPE = "Image" where IMAGE_PROTOTYPE = "LayoutImage"

alter table AV_IMAGE add column IMAGE_PARENT varchar(20) default NULL:

update AV_IMAGE set IMAGE_PARENT = IMAGE_F_IMAGE_PARENT, IMAGE_PARENT_PROTOTYPE = "Image" where IMAGE_F_IMAGE_PARENT is not null;
update AV_IMAGE set IMAGE_PARENT = IMAGE_F_SITE where IMAGE_F_SITE is not null and IMAGE_PARENT is null;
update AV_IMAGE set IMAGE_PARENT = IMAGE_F_LAYOUT where IMAGE_F_LAYOUT is not null and IMAGE_PARENT is null;

alter table AV_IMAGE add column IMAGE_METADATA mediumtext default NULL;

##
## Create table tag
##

CREATE TABLE `tag` (
  `id` int(11) NOT NULL,
  `site_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `type` enum('Story','Image') default NULL,
  PRIMARY KEY  (`id`),
  KEY `site_tags` (`site_id`,`type`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

##
## Create table tag_hub
##

CREATE TABLE `tag_hub` (
  `id` int(11) NOT NULL default '0',
  `tag_id` int(11) default NULL,
  `tagged_id` int(11) default NULL,
  `tagged_type` enum('Story','Image') default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tagged` (`tag_id`,`tagged_type`,`tagged_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

##
## Update table av_user
##

alter table av_user add column metadata mediumtext default NULL;

alter table av_user add column `status` enum('blocked','regular','trusted','privileged') not null default 'regular';
update av_user set status = 'regular';
update av_user set status = 'blocked' where user_isblocked = 1;
update av_user set status = 'trusted' where user_istrusted = 1;
update av_user set status = 'privileged' where user_issysadmin = 1;
   
alter table av_user add column hash varchar(32) default NULL;
alter table av_user add column salt varchar(12) default NULL;
update av_user set salt = conv(floor(0 + (rand() * pow(2, 48))), 10, 16), hash = md5(concat(user_password, salt));

##
## Update table av_site
##

alter table av_site add column `mode` enum('closed','restricted','public','open') not null;
update av_site set mode = 'public';
update av_site set mode = 'restricted' where site_isonline <> 1;

alter table av_site add column `status` enum('blocked','regular','trusted') not null;
update av_site set status = 'regular';
update av_site set status = 'blocked' where site_isblocked = 1;
update av_site set status = 'trusted' where site_istrusted = 1;

##
## Update table av_membership
##

alter table av_membership add column `role` enum('Subscriber','Contributor','Manager','Owner') not null default 'Subscriber';
update av_membership set role = 'Contributor' where membership_level = 9361;
update av_membership set role = 'Manager' where membership_level = 16383;
update av_membership set role = 'Owner' where membership_level = 131071;

##
## Update table av_accesslog
##

alter table av_accesslog add column `creator_id` mediumint(10);
alter table av_accesslog add column `action` varchar(255);
alter table av_accesslog add column `context_type` varchar(20);
update av_accesslog set context_type = 'Story', accesslog_f_site = accesslog_f_text where accesslog_f_text is not null;
update av_accesslog set context_type = 'Site' where accesslog_f_text is null;
update av_accesslog set creator_id = 0;
update av_accesslog set action = 'main';

##
## Update table av_file
##

alter table av_file add column metadata mediumtext;
alter table av_file add column parent_id mediumint(10);
alter table av_file add column parent_type varchar(30);
alter table av_file add column prototype varchar(30);

##
## Update table av_poll
##

alter table av_poll add column status enum('closed'.'readonly','open');
update av_poll set status = 'closed';
update av_poll set status = 'public' where poll_closed = 1;