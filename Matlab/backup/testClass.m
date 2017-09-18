clear all;close all;clc;

john = People('John',12,'male');
john.introduce('sad');

mary = People('Mary',14,'female');
mary.bark();
mary.introduce('happy');
% introduce(mary, 'happy');

bob = Animal('Bob',1','male');
bob.introduce('');


group1 = People();
group1(1,1)=john;
group1(2,1)=mary;