-- ===== DATE DIMENSIONS =====

CREATE TABLE d_years
(
  year_key UInt16,
  load_ts DateTime64,
  PRIMARY KEY (year_key)
)
ENGINE = MergeTree()
ORDER BY year_key;

CREATE TABLE d_months
(
  month_key UInt32,
  year_key UInt16,
  month_of_year UInt8,
  month_name String,
  quarter_of_year UInt8,
  load_ts DateTime64,
  PRIMARY KEY (month_key)
)
ENGINE = MergeTree()
ORDER BY month_key;

CREATE TABLE d_date
(
  date_key UInt32,
  month_key UInt32,
  full_date Date,
  day_of_month UInt8,
  day_of_week UInt8,
  day_name String,
  week_of_year UInt8,
  is_weekend UInt8,
  load_ts DateTime64,
  PRIMARY KEY (date_key)
)
ENGINE = MergeTree()
ORDER BY date_key;

-- ===== LOCATION DIMENSIONS =====

CREATE TABLE d_countries
(
  country_key UInt32,
  country_code_source FixedString(2),
  country_name String,
  load_ts DateTime64,
  PRIMARY KEY (country_key)
)
ENGINE = MergeTree()
ORDER BY country_key;

CREATE TABLE d_regions
(
  region_key UInt32,
  country_key UInt32,
  region_name_source String,
  load_ts DateTime64,
  PRIMARY KEY (region_key)
)
ENGINE = MergeTree()
ORDER BY region_key;

CREATE TABLE d_cities
(
  city_key UInt64,
  region_key UInt32,
  city_name_source String,
  load_ts DateTime64,
  PRIMARY KEY (city_key)
)
ENGINE = MergeTree()
ORDER BY city_key;

CREATE TABLE d_postal_codes
(
  postal_code_key UInt64,
  postal_code_source String,
  load_ts DateTime64,
  PRIMARY KEY (postal_code_key)
)
ENGINE = MergeTree()
ORDER BY postal_code_key;

CREATE TABLE d_addresses
(
  address_key UInt64,
  address_id_source Int64,
  street_address String,
  city_key UInt64,
  postal_code_key UInt64,
  load_ts DateTime64,
  PRIMARY KEY (address_key)
)
ENGINE = MergeTree()
ORDER BY address_key;

-- ===== ENTITY DIMENSIONS =====

CREATE TABLE d_customers
(
  customer_key UInt64,
  customer_id_source Int64,
  username String,
  email String,
  first_name String,
  last_name String,
  date_of_birth Date,
  default_shipping_address_key Nullable(UInt64),
  default_billing_address_key Nullable(UInt64),
  registration_date Date,
  load_ts DateTime64,
  source_system String,
  PRIMARY KEY (customer_key)
)
ENGINE = MergeTree()
ORDER BY customer_key;

CREATE TABLE d_sellers
(
  seller_key UInt64,
  seller_id_source Int64,
  company_name String,
  registration_date Date,
  is_active UInt8,
  load_ts DateTime64,
  source_system String,
  PRIMARY KEY (seller_key)
)
ENGINE = MergeTree()
ORDER BY seller_key;

CREATE TABLE d_categories
(
  category_key UInt64,
  category_id_source Int64,
  category_name String,
  parent_category_key Nullable(UInt64),
  load_ts DateTime64,
  source_system String,
  PRIMARY KEY (category_key)
)
ENGINE = MergeTree()
ORDER BY category_key;

CREATE TABLE d_products
(
  product_key UInt64,
  product_id_source Int64,
  product_name String,
  sku String,
  category_key UInt64,
  seller_key UInt64,
  description Nullable(String),
  tags Array(String),
  mongo_attributes Map(String, String),
  load_ts DateTime64,
  source_system String,
  PRIMARY KEY (product_key)
)
ENGINE = MergeTree()
ORDER BY product_key;

CREATE TABLE d_reviews
(
  review_key UInt64,
  review_id_source String,
  product_key UInt64,
  customer_key UInt64,

  rating UInt8,
  title Nullable(String),
  comment Nullable(String),
  image_urls Array(String),
  is_verified_purchase UInt8,

  review_created_at_source DateTime64,
  review_updated_at_source DateTime64,

  load_ts DateTime64,
  source_system String DEFAULT 'MongoDB',

  PRIMARY KEY (review_key)
)
ENGINE = MergeTree()
ORDER BY review_key;

-- ===== FACT TABLE =====

CREATE TABLE f_sales
(
  order_item_id_source Int64,
  order_id_source Int64,

  order_date_key UInt32,
  product_key UInt64,
  customer_key UInt64,
  seller_key UInt64,

  shipping_address_key UInt64,
  billing_address_key UInt64,

  quantity_sold Int32,
  unit_price_at_sale Decimal(10,2),
  total_amount_item Decimal(12,2),

  load_ts DateTime64,
  event_ts DateTime64,
  source_system String
)
ENGINE = MergeTree()
ORDER BY (order_date_key, seller_key, product_key, order_item_id_source);