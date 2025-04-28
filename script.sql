create database dbViagens;
use dbViagens;

-- tabela cliente
create table tbCliente (
  Nome varchar(50) not null,
  Sexo char(1) not null,
  Email varchar(50) not null,
  Telefone numeric(11) not null,
  Cpf numeric(11) not null,
  IdCliente int auto_increment primary key
);

-- tabela funcionario
create table tbFuncionario (
  Nome varchar(50) not null,
  Sexo char(1) not null,
  Email varchar(50) not null,
  Telefone numeric(11) not null,
  Cargo enum('Administrador', 'Gerente', 'Vendedor') not null,
  Cpf numeric(11) not null,
  IdFuncionario int auto_increment primary key
);

-- tabela produto 
create table tbProduto (
  IdProduto int auto_increment primary key, 
  NomeProduto varchar(50) not null,
  Valor decimal(10,2) not null,
  Descricao varchar(200) not null
);

-- tabela pacote
create table tbPacote (
  IdPacote int auto_increment primary key,
  NomePacote varchar(50) not null,
  Descricao varchar(200) not null,
  Valor decimal(10,2) not null
);

-- tabela produto pacote
create table tbProdutoPacote (
  Quantidade int not null,
  IdProduto int not null, 
  IdPacote int not null
);

-- tabela venda
create table tbVenda (
  IdVenda int auto_increment primary key,
  DataVenda datetime not null,
  TipoVenda enum('Avulsa', 'Pacote') not null,
  IdCliente int not null,
  Valor decimal(10,2) not null,
  IdFuncionario int not null
);

-- tabela viagem
create table tbViagem (
  IdViagem int auto_increment primary key,
  DataRetorno datetime not null,
  Origem varchar(200) not null,
  Destino varchar(200) not null,
  TipoTransporte enum('Ônibus', 'Avião') not null,
  DataPartida datetime not null
);

-- tabela passagem
create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento int not null,
  DataCompra datetime not null,
  IdViagem int not null,
  IdCliente int not null
);

-- tabela nota fiscal
create table tbNotaFiscal (
  IdNF int auto_increment primary key,
  IdVenda int not null,
  DataEmissao datetime
);

-- criando agora as foreign keys via alter table
alter table tbProdutoPacote
add constraint Fk_ProdutoPacote_Produto foreign key (IdProduto) references TbProduto (IdProduto),
add constraint Fk_ProdutoPacote_Pacote foreign key (IdPacote) references TbPacote (IdPacote);

alter table tbVenda
add constraint Fk_Venda_Cliente foreign key (IdCliente) references TbCliente (IdCliente),
add constraint Fk_Venda_Funcionario foreign key (IdFuncionario) references TbFuncionario (IdFuncionario);

alter table tbPassagem
add constraint Fk_Passagem_Viagem foreign key (IdViagem) references TbViagem (IdViagem),
add constraint Fk_Passagem_Cliente foreign key (IdCliente) references TbCliente (IdCliente);

alter table tbNotaFiscal
add constraint Fk_NotaFiscal_Venda foreign key (IdVenda) references TbVenda (IdVenda);

-- inserts
-- insert cliente
insert into tbCliente(Nome, Sexo, Email, Telefone, Cpf) values(
('João Silva', 'M', 'joao@email.com', 11999998888, 12345678900),
('Maria Souza', 'F', 'maria@email.com', 11988887777, 98765432100),
('Pedro Santos', 'M', 'pedro@email.com', 11977776666, 45678912300)
);
-- insert funcionario
insert into tbFuncionario(Nome, Sexo, Email, Telefone, Cpf, Cargo) values(
('Ana Pereira', 'F', 'ana.pereira@email.com', 11955556666, 11223344556, 'Administrador'),
('Carlos Silva', 'M', 'carlos.silva@email.com', 11944445555, 22334455667, 'Gerente'),
('Juliana Costa', 'F', 'juliana.costa@email.com', 11933334444, 33445566778, 'Vendedor')
);

-- insert pacote
insert into tbPacote (NomePacote, Descricao, Valor) values(
('Pacote Nordeste', 'Viagem para Salvador com hospedagem e café da manhã.', 2500.00),
('Pacote Sul', 'Viagem para Gramado com passeios e hospedagem inclusos.', 3200.50),
('Pacote Europa', 'Pacote completo para Paris com city tour e hotel 5 estrelas.', 12000.00)
);

-- insert viagem
insert into tbViagem (DataRetorno, Origem, Destino, TipoTransporte, DataPartida) values(
('2025-06-10 20:00:00', 'São Paulo', 'Salvador', 'Avião', '2025-06-03 08:00:00'),
('2025-07-15 18:00:00', 'Curitiba', 'Gramado', 'Ônibus', '2025-07-10 07:00:00'),
('2025-09-01 10:00:00', 'Rio de Janeiro', 'Paris', 'Avião', '2025-08-25 22:00:00')
);




