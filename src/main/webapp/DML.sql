-- DML : SELECT, INSERT, UPDATE, DELETE

select * from users;

select * from CATEGORY;

select * from PRODUCT;

select * from PRODUCT_IMAGE;

select * from AUCTION;

select * from BID;

select * from ORDERS;

select * from TRADE_OFFER;

select * from TRADE_DEAL;

select * from CHAT_ROOM;

select * from CHAT_MESSAGE;

-- USERS 테이블 Sample Data
insert into USERS values (USERS_SEQ.nextval, 'user1@fliq.com', 'user1password', 'user1');
insert into USERS values (USERS_SEQ.nextval, 'user2@fliq.com', 'user2password', 'user2');
insert into USERS values (USERS_SEQ.nextval, 'user3@fliq.com', 'user3password', 'user3');

-- CATEGORY 테이블 Sample Data
insert into CATEGORY values (CATEGORY_SEQ.nextval, 'category1');
insert into CATEGORY values (CATEGORY_SEQ.nextval, 'category2');
insert into CATEGORY values (CATEGORY_SEQ.nextval, 'category3');

-- PRODUCT 테이블 Sample Data
insert into PRODUCT (P_ID, P_USERS_ID, P_CATEGORY_ID, P_SALE_TYPE, P_TITLE, P_SALE_PRICE)
select PRODUCT_SEQ.nextval, u.u_id, c.c_id, 'SALE', 'product6', 11
from users u cross join category c
where u.U_EMAIL = 'user1@fliq.com' and c.C_NAME = 'category1';
insert into PRODUCT (P_ID, P_USERS_ID, P_CATEGORY_ID, P_SALE_TYPE, P_TITLE, P_SALE_PRICE)
select PRODUCT_SEQ.nextval, u.u_id, c.c_id, 'SALE', 'product7', 22
from users u cross join category c
where u.U_EMAIL = 'user2@fliq.com' and c.C_NAME = 'category2';
insert into PRODUCT (P_ID, P_USERS_ID, P_CATEGORY_ID, P_SALE_TYPE, P_TITLE, P_SALE_PRICE)
select PRODUCT_SEQ.nextval, u.u_id, c.c_id, 'SALE', 'product8', 33
from users u cross join category c
where u.U_EMAIL = 'user3@fliq.com' and c.C_NAME = 'category3';

-- CHAT_ROOM 테이블 sample data
insert into CHAT_ROOM (cr_id, CR_PRODUCT_ID, CR_SELLER_ID, CR_BUYER_ID)
values (CHAT_ROOM_SEQ.nextval, 23, 21, 22);

-- CHAT_MESSAGE 테이블 sample data
insert into CHAT_MESSAGE (cm_id, CM_CHAT_ROOM_ID, CM_SENDER_ID, CM_TEXT_BODY)
values (CHAT_ROOM_SEQ.nextval, 1, 21, '아직 판매하시나요?');

SELECT p.p_id, p.p_title, p.p_users_id, u.u_email, u.u_nickname
FROM product p
-- 상품에 저장된 판매자 번호로 회원 정보를 조회한다.
         JOIN users u ON u.u_id = p.p_users_id
WHERE p.p_title = 'hg1 판매자 연동 확인'
ORDER BY p.p_id DESC;
