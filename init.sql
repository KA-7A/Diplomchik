create database diplom;
use diplom;
create table USER_TYPE(
    ID  INT not null AUTO_INCREMENT,
    TYPE varchar(20) not null,

    unique(type),
    primary key (ID)
    );

create table SECRET_TYPE(
    ID  INT not null,
    TYPE varchar(20) not null,

    unique(type),
    primary key (ID)
);

create table ACTION_TYPE(
    ID  INT not null,
    TYPE varchar(10) not null,

    unique(type),
    primary key (ID)
);


create table RETURN_CODES(
    ID  INT not null,
    TYPE varchar(100) not null,

    unique(type),
    primary key (ID)
);

create table USERS(
    ID          MEDIUMINT       not null    AUTO_INCREMENT,
    NAME        VARCHAR(100)    not null,
    HASH        VARCHAR(64)     not null,
    SALT        VARCHAR(10)     not null,
    PRIVILEGED  BOOLEAN         not null,
    TYPE        INT             not null,

    unique (ID),
primary key(NAME)
);

create table CONTACTS(
    ID      MEDIUMINT   not null,
    CONTACT varchar(50) not null,
    foreign key (ID) references USERS(ID)
);

create table SECRETS(
    ID          MEDIUMINT  not null    AUTO_INCREMENT,
    TYPE        INT        not null,
    VALID_TO    date                    ,
    SECRET      TEXT(1024) not null,
    DESCRIPTION TEXT(1024),

    primary key (ID),
    foreign key (TYPE) references SECRET_TYPE(ID)
);

create table OWNERSHIP(
    USER_ID     MEDIUMINT   not null,
    SECRET_ID   MEDIUMINT   not null,
    primary key (SECRET_ID),
    foreign key (USER_ID)       references USERS(ID),
    foreign key (SECRET_ID)     references SECRETS(ID)
);

create table READABLE(
    USER_ID     MEDIUMINT   not null,
    SECRET_ID   MEDIUMINT   not null,
    foreign key (USER_ID)   references USERS(ID),
    foreign key (SECRET_ID) references SECRETS(ID)
);

create table LOGS(
    ID          BIGINT      not null    AUTO_INCREMENT,
    L_TIME      DATETIME    not null ,
    USER_ID     MEDIUMINT   not null ,
    USER_ACTION INT         not null ,
    RETURN_CODE INT         not null ,

primary key (ID),

foreign key (USER_ID)       references USERS(ID),

foreign key (USER_ACTION)   references ACTION_TYPE(ID),
foreign key (RETURN_CODE)   references RETURN_CODES(ID)
);

delimiter &&
create trigger i_ownership after insert on OWNERSHIP for each row
begin
    insert into READABLE values (new.USER_ID, new.SECRET_ID);
end&&

delimiter ;



insert into USER_TYPE (TYPE)        values ROW('human'), ROW('service'), ROW('other');
insert into SECRET_TYPE (ID, TYPE)  values ROW(0, 'other'), ROW(1, 'SSL'), ROW(2, 'API'), ROW(3, 'passwd');
insert into ACTION_TYPE (ID, TYPE)  values ROW(1, 'S'), ROW(2, 'U'), ROW(3, 'I'), ROW(4, 'D');
insert into RETURN_CODES (ID, TYPE) values  ROW(0, 'Ok'),
                                            ROW(-1, 'Incorrect login'),
                                            ROW(-2, 'Access denied'),
                                            ROW(-3, 'Secret was not found'),
                                            ROW(1,  'Login ok'),
                                            ROW(2,  'Access granted'),
                                            ROW(3,  'Secret was found');

insert into USERS (NAME, HASH, SALT, PRIVILEGED, TYPE) values
              ROW ('root', '_', '_', True, 2),
              ROW ('unknown', '_', '_', False, 3);

insert into SECRETS (TYPE, SECRET) values   ROW(3, 'Just password'),
                                            ROW(0, 'Some text'),
                                            ROW(0, 'Some more text');

insert into OWNERSHIP values ROW (1, 1), ROW (1, 2), ROW(2, 3);