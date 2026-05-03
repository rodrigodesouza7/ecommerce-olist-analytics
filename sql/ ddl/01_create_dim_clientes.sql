-- public.dim_clientes definição

-- Drop table

-- DROP TABLE public.dim_clientes;

CREATE TABLE public.dim_clientes (
	customer_id uuid NOT NULL,
	customer_city varchar NULL,
	customer_state varchar NULL,
	column1 int4 NULL,
	order_id varchar(50) NULL,
	order_item_id int4 NULL,
	customer_unique_id varchar(50) NULL,
	customer_zip_code_prefix int4 NULL,
	product_id varchar(50) NULL,
	product_category_name varchar(50) NULL,
	product_name_lenght float4 NULL,
	product_description_lenght float4 NULL,
	product_photos_qty float4 NULL,
	product_weight_g float4 NULL,
	product_length_cm float4 NULL,
	product_height_cm float4 NULL,
	product_width_cm float4 NULL,
	seller_id varchar(50) NULL,
	seller_city varchar(50) NULL,
	seller_state varchar(50) NULL,
	seller_zip_code_prefix int4 NULL,
	payment_type varchar(50) NULL,
	payment_sequential int4 NULL,
	payment_installments int4 NULL,
	price float4 NULL,
	freight_value float4 NULL,
	payment_value float4 NULL,
	shipping_limit_date varchar(50) NULL,
	order_purchase_timestamp varchar(50) NULL,
	order_approved_at varchar(50) NULL,
	order_delivered_carrier_date varchar(50) NULL,
	order_delivered_customer_date varchar(50) NULL,
	order_estimated_delivery_date varchar(50) NULL,
	day_of_purchase varchar(50) NULL,
	month_of_purchase varchar(50) NULL,
	year_of_purchase int4 NULL,
	"month/year_of_purchase" varchar(50) NULL,
	order_status varchar(50) NULL,
	order_unique_id varchar(50) NULL,
	CONSTRAINT dim_clientes_pkey PRIMARY KEY (customer_id)
);