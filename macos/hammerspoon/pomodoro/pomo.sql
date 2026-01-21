-- DB sqlite:~/.pomos.db
select * from pomos;

delete from pomos where name='pomo_test';
update pomos set time=0 where id=1;
