# 📋 Dicionário de Dados — Olist Sales Analytics

## 🗂️ Tabelas Dimensão

### dim_clientes
Dados cadastrais de clientes do e-commerce.

| Campo | Tipo | Nulo | Descrição |
|-------|------|------|-----------|
| customer_id | text | NOT NULL | Identificador único do cliente (PK) |
| customer_unique_id | text | NULL | ID original do dataset Olist |
| customer_city | text | NULL | Cidade onde o cliente está localizado |
| customer_state | bpchar(2) | NOT NULL | Estado (UF) do cliente (ex: SP, RJ, MG) |

**Chave Primária:** `customer_id`  
**Índices:**
- `idx_clientes_estado` em `customer_state`
- `idx_clientes_cidade` em `customer_city`

---

### dim_produtos
Catálogo de produtos vendidos no marketplace.

| Campo | Tipo | Nulo | Descrição |
|-------|------|------|-----------|
| product_id | text | NOT NULL | Identificador único do produto (PK) |
| categoria | text | NULL | Categoria do produto (ex: eletrônicos, móveis) |

**Chave Primária:** `product_id`  
**Índices:**
- `idx_produtos_categoria` em `categoria`

---

### dim_vendedores
Informações sobre vendedores do marketplace.

| Campo | Tipo | Nulo | Descrição |
|-------|------|------|-----------|
| seller_id | text | NOT NULL | Identificador único do vendedor (PK) |
| seller_city | text | NULL | Cidade onde o vendedor está localizado |
| seller_state | text | NULL | Estado (UF) onde o vendedor atua |

**Chave Primária:** `seller_id`  
**Índices:**
- `idx_vendedores_estado` em `seller_state`
- `idx_vendedores_cidade` em `seller_city`

---

## 📊 Tabelas Fato

### fato_pedidos
Transações de pedidos realizados no e-commerce.

| Campo | Tipo | Nulo | Descrição |
|-------|------|------|-----------|
| order_id | text | NOT NULL | Identificador único do pedido (PK) |
| customer_id | text | NOT NULL | FK para dim_clientes |
| order_purchase_timestamp | timestamp | NOT NULL | Data e hora em que o pedido foi realizado |

**Granularidade:** 1 linha = 1 pedido  
**Chave Primária:** `order_id`  
**Chaves Estrangeiras:**
- `customer_id` → `dim_clientes.customer_id`

**Índices:**
- `idx_pedidos_data` em `order_purchase_timestamp`
- `idx_pedidos_data_mes` em `DATE_TRUNC('month', order_purchase_timestamp)` (funcional)

---

### fato_itens
Itens vendidos em cada pedido (granularidade produto × pedido × vendedor).

| Campo | Tipo | Nulo | Descrição |
|-------|------|------|-----------|
| order_id | text | NOT NULL | FK para fato_pedidos |
| product_id | text | NOT NULL | FK para dim_produtos |
| seller_id | text | NOT NULL | FK para dim_vendedores |
| price | numeric | NOT NULL | Valor do produto no momento da venda |
| freight_value | numeric | NOT NULL | Valor do frete associado ao item |

**Granularidade:** 1 linha = 1 produto vendido em 1 pedido por 1 vendedor  
**Chave Primária Composta:** `(order_id, product_id, seller_id)`  
**Chaves Estrangeiras:**
- `order_id` → `fato_pedidos.order_id` (ON DELETE CASCADE)
- `product_id` → `dim_produtos.product_id`
- `seller_id` → `dim_vendedores.seller_id`

**Índices:**
- `idx_itens_order` em `order_id`
- `idx_itens_product` em `product_id`
- `idx_itens_seller` em `seller_id`

---

## 📝 Notas Técnicas

### Decisões de Modelagem

**Tipos `text` vs `uuid`:**
- Dataset original Olist usa strings alfanuméricas, não UUIDs nativos
- Tipo `text` preserva formato original dos dados

**PK Composta em `fato_itens`:**
- Combinação `(order_id, product_id, seller_id)` garante unicidade
- Permite mesmo produto vendido por sellers diferentes no mesmo pedido

**Índices Funcionais:**
- `idx_pedidos_data_mes`: Otimiza agregações mensais com `DATE_TRUNC()`

**Integridade Referencial:**
- `ON DELETE CASCADE` em `fato_itens → fato_pedidos`: Itens são deletados junto com pedido
- `ON DELETE RESTRICT` nas dimensões: Impede exclusão acidental de dados mestres

---

## 🔄 Histórico de Alterações

**Maio 2026:**
- Limpeza de 240 duplicatas em `fato_itens` antes de criar PK composta
- Índices de performance criados em todas as FKs
- View `vw_analise_final` para agregações multidimensionais