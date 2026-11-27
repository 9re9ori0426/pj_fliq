-- DDL : CREATE, ALTER, DROP, TRUNCATE, RENAME

create table users
(
    u_id       number(18, 0) primary key,
    u_email    varchar2(30 char) unique not null,
    u_password varchar2(30 char)        not null,
    u_nickname varchar2(30 char) unique not null,
--  email & nickname null / 공백 체크
    constraint ck_user_email check ( trim(u_email) is not null and u_email = lower(trim(u_email)) ),
    constraint ck_user_nick check ( trim(u_nickname) is not null and u_nickname = trim(u_nickname) )
);
create sequence users_seq;

create table category
(
    c_id   number(18, 0) primary key,
    c_name varchar2(10 char) unique not null,
--  name null / 공백 체크
    constraint ck_category_name check ( trim(c_name) is not null and c_name = trim(c_name) )
);
create sequence category_seq;

create table product
(
    p_id          number(18, 0) primary key,
    p_users_id    number(18, 0)                                    not null references users (u_id),
    p_category_id number(18, 0)                                    not null references category (c_id),
    p_sale_type   varchar2(10 char)                                not null,
    p_trade_ok    varchar2(5 char)            default 'N'          not null,
    p_title       varchar2(30 char)                                not null,
    p_description varchar2(500 char)                               null,
    p_sale_price  number(10, 0)                                    not null,
    p_sale_status varchar2(10 char)           default 'AVAILABLE'  not null,
    p_created_at  timestamp(6) with time zone default systimestamp not null,
    p_updated_at  timestamp(6) with time zone default systimestamp not null,
    p_deleted_at  timestamp(6) with time zone                      null,
--  id & users_id 두가지로 유일성 체크
    constraint uq_product_owners UNIQUE (p_id, p_users_id),
--  sale_type는 'SALE' or 'AUCTION'
    constraint ck_product_type check ( p_sale_type in ('SALE', 'AUCTION') ),
--  trade_ok는 'N' or 'Y'
    constraint ck_product_trade check ( p_trade_ok in ('N', 'Y') ),
--  sale_status는 'AVAILABLE' or 'RESERVED' or 'SOLD' or 'TRADED' or 'ENDED' or 'DELETED'
    constraint ck_product_status check ( p_sale_status in
                                         ('AVAILABLE', 'RESERVED', 'SOLD', 'TRADED', 'ENDED', 'DELETED') ),
--  title null check
    constraint ck_product_title check ( trim(p_title) is not null ),
--  sale_type != 'AUCTION' or sale_price = 0
    constraint ck_product_sale_type check ( p_sale_type <> 'AUCTION' or p_sale_price = 0 ),
--  0 <= sale_price <= 9999999999(10개)
    constraint ck_product_price check ( p_sale_price between 0 and 9999999999),
--  update time이 created time보다 나중이고,
--  (sale_status가 'DELETED'이고 delete time이 존재하고 created time보다 나중이거나,
--  sale_status가 'DELETED'가 아니고 delete time이 존재하지 않기)
    constraint ck_product_time check ( p_updated_at >= p_created_at and
                                       ((p_sale_status = 'DELETED' and p_deleted_at is not null and
                                         p_deleted_at >= p_created_at) or
                                        (p_sale_status <> 'DELETED' and p_deleted_at is null)) )
);
create sequence product_seq;

create table product_image
(
    pi_product_id number(18, 0) primary key references product (p_id),
    pi_storage    varchar2(255 char) not null unique
);

create table auction
(
    a_id             number(18, 0) primary key,
    a_product_id     number(18, 0) unique             not null references product (p_id),
    a_start_price    number(18, 0)                    not null,
    a_period_code    varchar2(2 char)                 not null,
    a_start_at       timestamp(6) with time zone      not null,
    a_end_at         timestamp(6) with time zone      not null,
    a_status         varchar2(12 char) default 'OPEN' not null,
    a_winning_bid_id number(18, 0)                    null,
    a_closed_at      timestamp(6) with time zone      null,
--  product_id & id 묶어서 유일성 체크
    constraint uq_auction_product UNIQUE (a_product_id, a_id),
--  1000 <= start_price <= 9999999999(10개)
    constraint ck_auc_start_price check ( a_start_price between 1000 and 999999999999 ),
--  period_code는 '1주' or '2주' or '3주' or '1달'
    constraint ck_auc_period check ( a_period_code in ('W1', 'W2', 'W3', 'M1') ),
--  auc_status는 'OPEN' or 'WON' or 'NO_BIDS' or 'CANCELLED' or 'TRADE_CLOSED'
    constraint ck_auc_status check ( a_status in ('OPEN', 'WON', 'NO_BIDS', 'CANCELLED', 'TRADE_CLOSED') ),
--  end time이 start time보다 늦음
    constraint ck_auc_end check ( a_end_at > a_start_at ),
--  status가 'OPEN'이고 낙찰 안됐고 마감시간이 없거나,
--  status가 'WON'이고 낙찰 됐고 마감시간이 있고 마감시간이이 end time보다 나중이거나,
--  status가 'NO_BIDS'이고 낙찰 안됐고 close time이 있고 close time이 end time보다 나중이거나,
--  status가 'CANCELLED'이거나 'TRADE_CLOSED'이고 낙찰 안됐고 close
    constraint ck_auc_result check ( (a_status = 'OPEN' and a_winning_bid_id is null and a_closed_at is null) or
                                     (a_status = 'WON' and a_winning_bid_id is not null and a_closed_at is not null and
                                      a_closed_at >= a_end_at) or
                                     (a_status = 'NO_BIDS' and a_winning_bid_id is null and a_closed_at is not null and
                                      a_closed_at >= a_end_at) or
                                     (a_status in ('CANCELLED', 'TRADE_CLOSED') and a_winning_bid_id is null and
                                      a_closed_at is not null and a_closed_at >= a_start_at and a_closed_at < a_end_at))
);
create sequence auction_seq;

create table bid
(
    b_id         number(18, 0) primary key,
    b_auction_id number(18, 0)                                    not null references auction (a_id),
    b_bidder_id  number(18, 0)                                    not null references users (u_id),
    b_amount     number(18, 0)                                    not null,
    b_created_at timestamp(6) with time zone default systimestamp not null,
    constraint uq_bid_auction unique (b_auction_id, b_id),
    constraint ck_bid_amount check ( b_amount between 1000 and 999999999999)
);
create sequence bid_seq;

create table orders
(
    o_id           number(18, 0) primary key,
    o_product_id   number(18, 0) unique                             not null references product (p_id),
    o_buyer_id     number(18, 0)                                    not null references users (u_id),
    o_auction_id   number(18, 0)                                    null,
    o_total_amount number(18, 0)                                    not null,
    o_completed_at timestamp(6) with time zone default systimestamp not null,
    constraint fk_ord_auc_product foreign key (o_product_id, o_auction_id) references auction (a_product_id, a_id),
    constraint ck_ord_total check ( o_total_amount between 0 and 999999999999)
);
create sequence orders_seq;

create table trade_offer
(
    to_id                 number(18, 0) primary key,
    to_target_product_id  number(18, 0)                                    not null,
    to_offered_product_id number(18, 0)                                    not null,
    to_sender_id          number(18, 0)                                    not null,
    to_receiver_id        number(18, 0)                                    not null,
    to_status             varchar2(9 char)            default 'PENDING'    not null,
    to_created_at         timestamp(6) with time zone default systimestamp not null,
    to_resolved_at        timestamp(6) with time zone                      null,
    constraint fk_offer_target foreign key (to_target_product_id, to_receiver_id) references product (p_id, p_users_id),
    constraint fk_offer_offered foreign key (to_offered_product_id, to_sender_id) references product (p_id, p_users_id),
    constraint ck_offer_pair check ( to_target_product_id <> to_offered_product_id and to_sender_id <> to_receiver_id ),
    constraint ck_offer_status check ( to_status in ('PENDING', 'ACCEPTED', 'REJECTED', 'WITHDRAWN', 'INVALID') ),
    constraint ck_offer_resolved check ( (to_status = 'PENDING' and to_resolved_at is null) or
                                         (to_status <> 'PENDING' and to_resolved_at is not null and
                                          to_resolved_at >= to_created_at) )
);
create sequence trade_offer_seq;

create table trade_deal
(
    td_id                   number(18, 0) primary key,
    td_trade_offer_id       number(18, 0) unique                              not null references trade_offer (to_id),
    td_status               varchar2(11 char)           default 'IN_PROGRESS' not null,
    td_accepted_at          timestamp(6) with time zone default systimestamp  not null,
    td_sender_received_at   timestamp(6) with time zone                       null,
    td_receiver_received_at timestamp(6) with time zone                       null,
    constraint ck_deal_status check ( td_status in ('IN_PROGRESS', 'COMPLETED') ),
    constraint ck_deal_receipt check (
        (td_status = 'COMPLETED' and td_sender_received_at is not null and td_receiver_received_at is not null) or
        (td_status = 'IN_PROGRESS' and (td_sender_received_at is null or td_receiver_received_at is null)))
);
create sequence trade_deal_seq;

create table chat_room
(
    cr_id         number(18, 0) primary key,
    cr_product_id number(18, 0)                                    not null,
    cr_seller_id  number(18, 0)                                    not null,
    cr_buyer_id   number(18, 0)                                    not null references users (u_id),
    cr_created_at timestamp(6) with time zone default systimestamp not null,
    constraint uq_room_list_buyer unique (cr_product_id, cr_buyer_id),
    constraint fk_room_list_seller foreign key (cr_product_id, cr_seller_id) references product (p_id, p_users_id),
    constraint ck_room_parties check ( cr_buyer_id <> cr_seller_id )
);
create sequence chat_room_seq;

create table chat_message
(
    cm_id           number(18, 0) primary key,
    cm_chat_room_id number(18, 0)                                    not null references chat_room (cr_id),
    cm_sender_id    number(18, 0)                                    not null references users (u_id),
    cm_text_body    varchar2(100 char)                               not null,
    cm_created_at   timestamp(6) with time zone default systimestamp not null,
    constraint ck_msg_text_body check ( trim(cm_text_body) is not null and length4(cm_text_body) between 1 and 100)
);
create sequence chat_message_seq;

ALTER TABLE auction
    ADD CONSTRAINT fk_auc_win_bid
        FOREIGN KEY (a_id, a_winning_bid_id)
            REFERENCES bid (b_auction_id, b_id);

