markdow# 📐 Normalização do Banco de Dados — Olist Sales Analytics

## 1. Fundamentos da Normalização

A normalização é o processo de estruturação de um banco de dados relacional para:

- **Reduzir redundância** de dados armazenados
- **Garantir integridade** referencial
- **Eliminar anomalias** de inserção, atualização e exclusão
- **Facilitar manutenção** do esquema

## 2. Normalização nas Dimensões (3FN)

As tabelas de dimensão (`dim_clientes`, `dim_produtos`, `dim_vendedores`) foram modeladas seguindo a **Terceira Forma Normal (3FN)**, garantindo que:

### ✅ Primeira Forma Normal (1FN)

- Todos os atributos contêm valores atômicos (não há listas ou arrays)
- Cada coluna contém apenas um tipo de dado
- Cada registro é único (garantido pela chave primária)

### ✅ Segunda Forma Normal (2FN)

- Satisfaz 1FN
- Não há dependências parciais (todos os atributos não-chave dependem da chave primária completa)
- Como as dimensões têm chaves primárias simples (não compostas), 2FN é automaticamente satisfeita

### ✅ Terceira Forma Normal (3FN)

- Satisfaz 2FN
- Não há dependências transitivas (atributos não-chave não dependem de outros atributos não-chave)
- Cada atributo depende **exclusivamente** da chave primária

### 📋 Análise de Dependências Funcionais

#### dim_clientes

customer_id → customer_unique_id
customer_id → customer_city
customer_id → customer_state
✅ **3FN:** Todos os atributos dependem exclusivamente de `customer_id`  
✅ **Sem redundância:** Cada cliente aparece uma única vez

#### dim_produtos

product_id → categoria
✅ **3FN:** `categoria` depende exclusivamente de `product_id`  
✅ **Sem dependências transitivas:** Não há atributos derivados

#### dim_vendedores

seller_id → seller_city
seller_id → seller_state
✅ **3FN:** Localização do vendedor depende exclusivamente de `seller_id`  
✅ **Sem redundância:** Cada vendedor aparece uma única vez

## 3. Desnormalização Controlada nas Tabelas Fato

As tabelas fato (`fato_pedidos`, `fato_itens`) **não seguem completamente a 3FN** por decisão arquitetural justificada:

### 🎯 Razões para Desnormalização

#### Otimização para OLAP (Online Analytical Processing)

- Queries analíticas priorizam **leitura agregada** sobre escritas normalizadas
- Redução de JOINs complexos em consultas de BI
- Melhoria de performance em operações `SUM()`, `COUNT()`, `AVG()`

#### Granularidade Específica

- `fato_pedidos`: 1 linha = 1 pedido
- `fato_itens`: 1 linha = 1 produto × 1 pedido × 1 vendedor

#### Trade-off Consciente

- ✅ **Ganha:** Performance em agregações (90% das queries)
- ✅ **Ganha:** Simplicidade em análises multidimensionais
- ⚠️ **Perde:** Ligeiro aumento de armazenamento (aceitável em contexto analítico)

### 📊 Estrutura de fato_itens

**Chave Primária Composta:**

```sql
PRIMARY KEY (order_id, product_id, seller_id)
```

**Por que composta?**

- Permite que o **mesmo produto** seja vendido por **sellers diferentes** no mesmo pedido
- Evita duplicatas (240 registros duplicados foram removidos durante implementação)
- Mantém granularidade necessária para análises de performance por vendedor

**Chaves Estrangeiras:**
fato_itens.order_id → fato_pedidos.order_id (ON DELETE CASCADE)
fato_itens.product_id → dim_produtos.product_id (ON DELETE RESTRICT)
fato_itens.seller_id → dim_vendedores.seller_id (ON DELETE RESTRICT)

## 4. Integridade Referencial

### 🔗 Estratégias de Integridade

#### ON DELETE CASCADE

```sql
fato_itens → fato_pedidos (CASCADE)
```

**Justificativa:** Se um pedido é deletado, seus itens **devem** ser deletados junto (dependência hierárquica)

#### ON DELETE RESTRICT

```sql
fato_pedidos → dim_clientes (RESTRICT)
fato_itens   → dim_produtos (RESTRICT)
fato_itens   → dim_vendedores (RESTRICT)
```

**Justificativa:** Dados mestres (dimensões) **não podem** ser deletados se houver transações vinculadas (proteção contra perda de dados)

#### ON UPDATE CASCADE

Aplicado em **todas as FKs** para manter consistência caso IDs sejam atualizados (cenário raro em dados históricos)

### 📋 Mapa Completo de Relacionamentos

dim_clientes (1) ──────────< (N) fato_pedidos
│
│ (1)
│
▼
(N) fato_itens (N) ────────> (1) dim_produtos
│
│ (N)
│
▼
(1) dim_vendedores

## 5. Qualidade de Dados Implementada

### ✅ Limpeza Pré-Normalização

- **240 duplicatas** removidas de `fato_itens` antes de criar PK composta
- Método: `SELECT DISTINCT ON (order_id, product_id, seller_id)`
- Impacto: Garantiu unicidade sem perda de dados relevantes

### ✅ Constraints Aplicadas

- **5 Primary Keys** (1 por tabela)
- **4 Foreign Keys** (integridade entre fatos e dimensões)
- **15 índices** (otimização de JOINs e filtros temporais/geográficos)

## 6. Análise de Trade-offs

| Aspecto                      | 3FN Pura                | Star Schema (Implementado)        |
| ---------------------------- | ----------------------- | --------------------------------- |
| **Redundância**              | Mínima                  | Controlada (apenas FKs repetidas) |
| **Performance de Leitura**   | Moderada (muitos JOINs) | Alta (JOINs otimizados)           |
| **Performance de Escrita**   | Alta                    | Moderada                          |
| **Complexidade de Queries**  | Alta                    | Baixa                             |
| **Escalabilidade Analítica** | Limitada                | Excelente                         |
| **Integridade**              | Garantida               | Garantida (via FKs)               |

## 7. Validação de Normalização

### ✅ Testes de Integridade Executados

#### Teste 1: Verificar Órfãos

```sql
-- Pedidos sem cliente (deve retornar 0)
SELECT COUNT(*)
FROM fato_pedidos fp
LEFT JOIN dim_clientes dc ON fp.customer_id = dc.customer_id
WHERE dc.customer_id IS NULL;
```

**Resultado:** 0 registros órfãos ✅

#### Teste 2: Verificar Duplicatas

```sql
-- Itens duplicados (deve retornar 0)
SELECT order_id, product_id, seller_id, COUNT(*)
FROM fato_itens
GROUP BY order_id, product_id, seller_id
HAVING COUNT(*) > 1;
```

**Resultado:** 0 duplicatas ✅

## 8. Conclusão

O modelo implementado aplica **normalização estratégica**:

### ✅ Dimensões em 3FN

- Eliminação total de redundância
- Consistência de dados mestres
- Facilita manutenção de catálogos

### ✅ Fatos em Star Schema

- Otimização para análises OLAP
- Performance superior em agregações
- Simplicidade em queries de negócio

### ✅ Integridade Garantida

- FKs com políticas `CASCADE/RESTRICT` apropriadas
- PKs compostas onde necessário
- Índices em todos os pontos de junção

Esta abordagem híbrida é considerada **best practice** em Data Warehousing e Business Intelligence, balanceando teoria de normalização com requisitos práticos de performance analítica.

## 📚 Referências Técnicas

- **Codd, E.F.** (1970). "A Relational Model of Data for Large Shared Data Banks"
- **Kimball, R.** (2013). "The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling"
- **Inmon, W.H.** (2005). "Building the Data Warehouse"
