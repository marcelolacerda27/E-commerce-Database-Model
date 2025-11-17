-- Criação do Banco de Dados
CREATE DATABASE ecommerce_model;
USE ecommerce_model;

-- -----------------------------------------------------
-- 1. CLIENTES (Tabela Pai e Filhas)
-- -----------------------------------------------------

-- Tabela Base (Dados comuns a todos)
CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    client_type ENUM('PJ', 'PF') NOT NULL, -- Define o tipo para validação
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Pessoa Física (PF)
CREATE TABLE clients_pf (
    id_client INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    CONSTRAINT fk_pf_client FOREIGN KEY (id_client) REFERENCES clients(id)
);

-- Tabela Pessoa Jurídica (PJ)
CREATE TABLE clients_pj (
    id_client INT PRIMARY KEY,
    corporate_name VARCHAR(100) NOT NULL, -- Razão Social
    trade_name VARCHAR(100),              -- Nome Fantasia
    cnpj CHAR(14) NOT NULL UNIQUE,
    state_inscription VARCHAR(20),
    CONSTRAINT fk_pj_client FOREIGN KEY (id_client) REFERENCES clients(id)
);

-- -----------------------------------------------------
-- 2. ENDEREÇOS (Adição Necessária)
-- -----------------------------------------------------
-- Um cliente pode ter vários endereços (Cobrança e Entrega)
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    street VARCHAR(150) NOT NULL,
    number VARCHAR(10),
    complement VARCHAR(50),
    neighborhood VARCHAR(50),
    city VARCHAR(50),
    state CHAR(2),
    zip_code CHAR(8) NOT NULL,
    address_type ENUM('Shipping', 'Billing', 'Both') DEFAULT 'Both',
    CONSTRAINT fk_address_client FOREIGN KEY (id_client) REFERENCES clients(id)
);

-- -----------------------------------------------------
-- 3. PRODUTOS E ESTOQUE (Adição Necessária)
-- -----------------------------------------------------
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sku VARCHAR(50) UNIQUE, -- Código único do produto
    stock_quantity INT DEFAULT 0
);

-- -----------------------------------------------------
-- 4. MÉTODOS DE PAGAMENTO (Carteira do Cliente)
-- -----------------------------------------------------
-- Permite cadastrar mais de uma forma de pagamento por cliente
CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    method_type ENUM('Credit_Card', 'Debit_Card', 'Pix_Key') NOT NULL,
    provider VARCHAR(50), -- Ex: Visa, Mastercard
    card_last_four CHAR(4), -- Guardar apenas os últimos dígitos por segurança
    token_gateway VARCHAR(255), -- Token retornado pelo gateway de pagamento
    CONSTRAINT fk_payment_client FOREIGN KEY (id_client) REFERENCES clients(id)
);

-- -----------------------------------------------------
-- 5. PEDIDOS (O coração do sistema)
-- -----------------------------------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    order_status ENUM('Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_client FOREIGN KEY (id_client) REFERENCES clients(id)
);

-- Itens do Pedido
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_order INT NOT NULL,
    id_product INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL, -- Preço no momento da compra
    CONSTRAINT fk_items_order FOREIGN KEY (id_order) REFERENCES orders(id),
    CONSTRAINT fk_items_product FOREIGN KEY (id_product) REFERENCES products(id)
);

-- -----------------------------------------------------
-- 6. PAGAMENTO DO PEDIDO (Transação Real)
-- -----------------------------------------------------
-- Registra como um pedido específico foi pago
CREATE TABLE order_payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_order INT NOT NULL,
    id_payment_method INT, -- Pode ser nulo se for boleto avulso ou Pix direto
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pay_order FOREIGN KEY (id_order) REFERENCES orders(id),
    CONSTRAINT fk_pay_method FOREIGN KEY (id_payment_method) REFERENCES payment_methods(id)
);

-- -----------------------------------------------------
-- 7. ENTREGA (Delivery)
-- -----------------------------------------------------
-- Atende ao requisito de status e código de rastreio
CREATE TABLE deliveries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_order INT NOT NULL,
    id_address INT NOT NULL, -- Endereço de entrega escolhido
    tracking_code VARCHAR(50),
    delivery_status ENUM('Preparing', 'Dispatched', 'In_Transit', 'Delivered', 'Failed') DEFAULT 'Preparing',
    shipping_company VARCHAR(50), -- Transportadora
    estimated_delivery DATE,
    CONSTRAINT fk_delivery_order FOREIGN KEY (id_order) REFERENCES orders(id),
    CONSTRAINT fk_delivery_address FOREIGN KEY (id_address) REFERENCES addresses(id)
);