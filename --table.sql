CREATE TABLE "order"(
    order_uid  VARCHAR(50) PRIMARY KEY,
    track_number  VARCHAR(50) NOT NULL UNIQUE,
    "entry"  VARCHAR(50) NOT NULL,
    locale  VARCHAR(2) NOT NULL,
    internal_signature  VARCHAR(50) NOT NULL,
    customer_id  VARCHAR(50) NOT NULL,
    delivery_service  VARCHAR(50) NOT NULL,
    shardkey  VARCHAR(50) NOT NULL,
    sm_id BIGINT CHECK (sm_id > 0),
    date_created TIMESTAMP NOT NULL,
    oof_shard  VARCHAR(50) NOT NULL
);

CREATE TABLE DELIVERY(
    order_id VARCHAR(50) PRIMARY KEY REFERENCES "order"(order_uid),
    "name" VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    "address" VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE PAYMENT(
    order_id VARCHAR(50) PRIMARY KEY REFERENCES "order"(order_uid),
    transaction VARCHAR(50) NOT NULL,
    request_id VARCHAR(50) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    provider VARCHAR(50) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_dt BIGINT NOT NULL,
    bank VARCHAR(50) NOT NULL,
    delivery_cost NUMERIC(10, 2) NOT NULL,
    goods_total INTEGER NOT NULL,
    custom_fee NUMERIC(10, 2) NOT NULL
);

CREATE TABLE ITEM(
    id SERIAL PRIMARY KEY,
    order_id  VARCHAR(50) REFERENCES "order"(order_uid),
    chrt_id BIGINT NOT NULL,
    track_number VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) CHECK (price >= 0) NOT NULL,
    rid VARCHAR(50) NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    sale INTEGER CHECK(sale >=0 AND sale <= 100) NOT NULL,
    size VARCHAR(10) NOT NULL,
    total_price NUMERIC(10, 2) CHECK (total_price >= 0) NOT NULL,
    nm_id BIGINT NOT NULL,
    brand VARCHAR(50) NOT NULL,
    "status" INTEGER NOT NULL
);