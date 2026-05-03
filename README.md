## 🗄️ Modelo de Dados

**Arquitetura:** Star Schema

**Dimensões:**

- `dim_clientes` - Dados cadastrais de clientes
- `dim_produtos` - Catálogo de produtos
- `dim_vendedores` - Informações de sellers

**Fatos:**

- `fato_pedidos` - Transações de pedidos
- `fato_itens` - Itens de cada pedido

## ▶️ Como Reproduzir

### Pré-requisitos

- PostgreSQL 15 ou superior
- DBeaver ou pgAdmin

### 1. Clonar repositório

```bash
git clone https://github.com/seu-usuario/ecommerce-olist-analytics.git
cd ecommerce-olist-analytics
```

### 2. Baixar dataset

- Acesse: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- Baixe e extraia os CSVs na pasta `dados/`

### 3. Criar banco de dados

```sql
CREATE DATABASE olist_analytics;
```

### 4. Executar scripts DDL

Execute os scripts na pasta `sql/ddl/` na ordem numérica

### 5. Carregar dados

Execute os scripts na pasta `sql/dml/` para popular as tabelas

## 📊 Análises Implementadas

1. Evolução da receita mensal
2. Produtos mais vendidos por categoria
3. Distribuição geográfica de vendas
4. Performance de vendedores
5. Lifetime Value (LTV) de clientes

## 🎓 Contexto Acadêmico

Projeto desenvolvido como parte do curso de **Análise e Desenvolvimento de Sistemas (Estácio)**, aplicando:

- Modelagem dimensional (Star Schema)
- Normalização (3FN)
- Integridade referencial
- SQL avançado (agregações, window functions, CTEs)

## 📝 Status do Projeto

- [x] Modelagem conceitual
- [x] Implementação DDL
- [x] Pipeline ETL (staging → dimensões → fatos)
- [x] Carga de dados
- [ ] Queries analíticas
- [ ] Views de negócio
- [ ] Relatório final

## 👤 Autor

**Rodrigo de Souza Silva**

- GitHub: [@seu-usuario](https://github.com/seu-usuario)
- LinkedIn: [seu-perfil](https://linkedin.com/in/seu-perfil)

## 📄 Licença

MIT License - Projeto acadêmico de portfólio
