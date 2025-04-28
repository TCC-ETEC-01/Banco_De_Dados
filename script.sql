CREATE DATABASE dbViagens;
USE dbViagens;

-- tabela cliente
create table tbCliente(
Sexo char(1) not null,
Email varchar(50) not null,
Telefone numeric(11) not null,
Cpf numeric(11) not null,
IdCliente int auto_increment primary key
);

-- tabela funcionario
create table tbFuncionario(
Sexo char(1) not null,
Email varchar(50) not null,
Telefone numeric(11) not null,
Cargo varchar(50) not null,
Cpf numeric(11) not null,
IdFuncionario int auto_increment primary key
);

-- tabela produto 
create table tbProduto(
IdProduto int primary key auto_increment, 
NomeProduto varchar(50) not null,
Valor int not null,
Descricao varchar(200) not null
);

-- tabela pacote
create table tbPacote(
IdPacote int primary key auto_increment,
NomePacote varchar(50) not null,
Descricao varchar(200) not null,
Valor int not null
);

-- tabela produto pacote
create table tbProdutoPacote(
quantidade int not null,
IdProduto int auto_increment not null, 
foreign key(IdProduto) references tbProduto(IdProduto),
IdPacote int auto_increment not null,
foreign key(IdPacote) references tbPacote(IdPacote)
);

-- tabela venda
create table tbVenda(
IdVenda int primary key auto_increment,
DataVenda datetime not null,
TipoVenda enum('Avulsa', "Pacote") not null,
IdCliente int auto_increment not null, 
Valor int not null,
foreign key (IdCliente) references tbCliente (IdCliente),
IdFuncionario int auto_increment not null, 
foreign key (IdFuncionario) references tbFuncionario (IdFuncionario)
);

-- tabela viagem
create table tbViagem(
IdViagem int primary key auto_increment,
DataRetorno datetime not null,
Origem varchar(200) not null,
Destino varchar(200) not null,
TipoTransporte enum('Ônibus', 'Avião'),
DataPartida datetime not null
);

-- tabela passagem
create table tbPassagem(
IdPassagem int primary key auto_increment,
Assento int not null,
DataCompra datetime not null,
IdViagem int auto_increment not null, 
foreign key (IdViagem) references tbViagem(IdViagem),
IdCliente int auto_increment not null,
foreign key(IdCliente) references tbCliente(IdCliente)
);

-- tabela nota fiscal
create table tbNotaFiscal(
IdNF int primary key auto_increment,
IdVenda int auto_increment not null,
foreign key(IdVenda) references tbVenda(IdVenda),
DataEmissao datetime
);

