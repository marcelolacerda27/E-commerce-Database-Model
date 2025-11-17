# 🛒 E-commerce Database Model

Este projeto consiste na modelagem lógica e física de um banco de dados para um sistema de E-commerce. O objetivo principal foi refinar um modelo conceitual básico, implementando regras de negócio específicas como a distinção entre clientes PF/PJ, múltiplos meios de pagamento e rastreamento de entregas.

## 📋 Sobre o Projeto

O desafio foi criar um esquema relacional robusto utilizando **MySQL**, focado em resolver gargalos comuns em modelagens simples. O script SQL resultante cria uma estrutura escalável que suporta operações complexas de varejo online.

### 🚀 Funcionalidades e Regras de Negócio Atendidas

1.  **Cliente PF e PJ (Generalização/Especialização):**
    * Implementação de uma tabela mãe `clients` para dados de login.
    * Separação de dados sensíveis em tabelas filhas `clients_pf` (CPF) e `clients_pj` (CNPJ).
    * Regra de unicidade: Uma conta não pode ser PF e PJ simultaneamente.

2.  **Múltiplos Meios de Pagamento:**
    * O sistema permite que um cliente cadastre diversas formas de pagamento (ex: múltiplos cartões de crédito e chaves Pix).
    * Separação entre "Carteira do Cliente" (métodos salvos) e "Pagamento do Pedido" (transação efetiva).

3.  **Logística e Entrega:**
    * Tabela específica para `deliveries`, vinculada ao pedido.
    * Inclusão de `tracking_code` (código de rastreio) e status de entrega detalhado.
    * Suporte a múltiplos endereços por cliente (Cobrança vs. Entrega).

## 🛠️ Tecnologias Utilizadas

* **MySQL**
* **SQL** (DDL - Data Definition Language)
* **Modelagem de Dados** (Conceito EER - Enhanced Entity-Relationship)

## 📂 Estrutura do Banco de Dados

O modelo é composto pelas seguintes tabelas principais:

* `clients`: Tabela base para usuários.
* `clients_pf` / `clients_pj`: Especializações do cliente.
* `products`: Catálogo de itens com controle de estoque.
* `orders`: Cabeçalho dos pedidos.
* `order_items`: Detalhes dos produtos em cada pedido (N:N).
* `payments`: Histórico financeiro dos pedidos.
* `deliveries`: Controle logístico.

## 🏁 Como Executar

1.  Certifique-se de ter o **MySQL** instalado.
2.  Clone este repositório:
    ```bash
    git clone [https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git](https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git)
    ```
3.  Abra o seu terminal ou cliente MySQL (Workbench, DBeaver, etc).
4.  Execute o script `ecommerce_script.sql` (ou o nome que você deu ao arquivo) para criar o banco e as tabelas.

## 📌 Melhorias Futuras

* Implementar *Stored Procedures* para automatizar a inserção de pedidos.
* Criar *Triggers* para validação de CPF/CNPJ antes da inserção.
* Adicionar sistema de avaliações e reviews de produtos.

---
Desenvolvido por Marcelo Lacerda.
