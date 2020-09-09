create table memo (id serial primary key, title varchar(255), body text, UNIQUE (title, body));
