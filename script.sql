drop database dbAnu;
create database dbAnu;
use dbAnu;
show tables;

-- tabela cliente
create table tbCliente (
  Nome varchar(50) not null,
  Sexo enum('M', 'F') not null,
  Email varchar(50) not null,
  Telefone char(11) not null,
  Cpf char(11) not null,
  IdCliente int auto_increment primary key
);

create table tbFuncionario (
  Nome varchar(50) not null,
  Sexo enum('M', 'F') not null,
  Email varchar(50) not null,
  Telefone char(11) not null,
  Cargo varchar(50) not null,
  Cpf char(11) not null,
  Senha char(8) not null,
  IdFuncionario int auto_increment primary key
);

create table tbProduto (
  IdProduto int auto_increment primary key, 
  NomeProduto varchar(50) not null,
  Valor decimal(10,2) not null,
  Descricao Text not null,
  Quantidade int not null
);

create table tbPacote (
  IdPacote int auto_increment primary key,
  IdProduto int not null,
  IdPassagem int not null,
  NomePacote varchar(50) not null,
  Descricao text not null,
  Valor decimal(10,2) not null
);

create table tbViagem (
  IdViagem int auto_increment primary key,
  DataRetorno datetime not null,
  Descricao text not null,
  Origem varchar(200) not null,
  Destino varchar(200) not null,
  TipoTransporte enum('Ônibus', 'Avião') not null,
  DataPartida datetime not null
);

create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento char(5) not null,
  Valor decimal(10,2) not null,
  DataCompra datetime,
  IdViagem int not null,
  IdCliente int,
  Situacao varchar(50)
);
drop table tbLogs;
create table tbLogs(
	Usuario varchar(50) not null,
    DataLog datetime not null,
    Acao Text not null
);
-- criando foreign keys via alter table
alter table tbPassagem
add constraint FkViagem foreign key (IdViagem) references tbViagem(IdViagem),
add constraint FkPassagemCliente foreign key (IdCliente) references tbCliente(IdCliente);

alter table tbPacote 
add constraint FkPassagemPacote foreign key(IdPassagem) references tbPassagem(IdPassagem),
add constraint FkProdutoPacote foreign key(IdProduto) references tbProduto(IdProduto);

alter table tbProduto
add constraint FkPacoteProduto foreign key(IdPacote) references tbPacote(IdPacote);

-- inserts
-- insert cliente
insert into tbCliente(Nome, Sexo, Email, Telefone, Cpf) values(
'João Silva', 'M', 'joao@email.com', '11999998888', '12345678900'),
('Maria Souza', 'F', 'maria@email.com', 11988887777, 98765432100),
('Pedro Santos', 'M', 'pedro@email.com', 11977776666, 45678912300);

-- insert funcionario
insert into tbFuncionario(Nome, Sexo, Email, Telefone, Cpf, Cargo, Senha) values(
'Ana Pereira', 'F', 'ana.pereira@email.com', 11955556666, 11223344556, 'Administrador', 'Ana123'),
('Carlos Silva', 'M', 'carlos.silva@email.com', 11944445555, 22334455667, 'Gerente', "Car123"),
('Juliana Costa', 'F', 'juliana.costa@email.com', 11933334444, 33445566778, 'Vendedor', 'Ju123');

-- insert viagem
insert into tbViagem (DataRetorno, Descricao, Origem, Destino, TipoTransporte, DataPartida)
values 
('2025-05-20 14:00:00', 'Viagem para o Rio de Janeiro com hospedagem e city tour', 'São Paulo', 'Rio de Janeiro', 'Ônibus', '2025-05-18 08:00:00'),
('2025-06-10 18:00:00', 'Passagem aérea para Buenos Aires com pacote completo', 'São Paulo', 'Buenos Aires', 'Avião', '2025-06-08 12:00:00'),
('2025-07-01 16:00:00', 'Excursão para Foz do Iguaçu com guias especializados', 'Curitiba', 'Foz do Iguaçu', 'Ônibus', '2025-06-29 07:00:00'),
('2025-08-15 20:00:00', 'Pacote família para Bahia', 'Rio de Janeiro', 'Salvador', 'Avião', '2025-08-10 09:00:00'),
('2025-09-05 17:00:00', 'Tour wine em Mendoza', 'Porto Alegre', 'Mendoza', 'Avião', '2025-09-01 11:00:00');

-- insert passagem
insert into tbPassagem (IdViagem, IdCliente, Assento, Valor, Situacao, DataCompra) values
(1, 2, '14B', 850.00, 'Vendida', '2025-04-15 10:30:00'),
(2, null, '22C', 1200.00, 'Disponível', null),
(3, 3, '08A', 650.00, 'Vendida', '2025-03-20 14:15:00'),
(4, null, '15D', 950.00, 'Disponível', null),
(5, null, '09F', 1100.00, 'Disponível', null);

-- insert pacote
insert into tbPacote (IdProduto, IdPassagem, NomePacote, Descricao, Valor) values
(1, 1, 'Pacote Rio Econômico', 'Inclui passagem de ônibus e 3 noites de hospedagem', 1250.00),
(2, 2, 'Pacote Buenos Aires Premium', 'Passagem aérea + city tour + transfer', 1550.00),
(3, 3, 'Pacote Foz Aventura', 'Passagem de ônibus + transfer + passeio de barco', 950.00),
(4, 4, 'Pacote Família Bahia', 'Passagem aérea + transfer + seguro viagem', 1150.00),
(5, 5, 'Pacote Mendoza Vinho', 'Passagem aérea + seguro + tour vinícola', 1350.00);
-- insert produto
insert into tbProduto (NomeProduto, Valor, Descricao, Quantidade) values
('Hospedagem 3 estrelas', 450.00, 'Diária em hotel 3 estrelas com café da manhã', 10),
('City Tour Completo', 150.00, 'Passeio guiado pelas principais atrações', 20),
('Transfer Aeroporto', 80.00, 'Transporte privativo do aeroporto ao hotel', 15),
('Passeio de Barco', 200.00, 'Passeio de barco com almoço incluso', 8),
('Seguro Viagem', 120.00, 'Cobertura básica para viagens nacionais', 30);
-- selects
select * from tbPassagem;
select * from tbProduto;
select * from tbPacote;
select * from tbCliente;
select * from tbFuncionario;
select * from tbViagem;
select * from tbLogs;

-- criando procedures
delimiter $$
create procedure situacaoPassagem(
in Id int 
)
	begin
		select * from tbPassagem
        where IdCliente is null and Situacao = 'Disponivel';
    end $$
    delimiter ;
call situacaoPassagem(0);
/*
delimiter $$
create procedure ComprarPacote(
in NomePacote varchar(50), 
in IdCliente int 
)
begin
    declare vIdPacote int;
	declare vValorPacote decimal(10,2);
    declare vIdVenda int;
    declare vIdFuncionario int default 1;
    
    -- buscando o id e o valor do pacote
    select IdPacote, Valor
    into vIdPacote, vValorPacote
    from tbPacote
    where tbPacote.NomePacote = NomePacote
    limit 1;
    
    -- criando a venda
  insert into tbVenda (IdCliente, IdFuncionario, DataVenda, Valor)
    values (IdCliente, vIdFuncionario, CURDATE(), vValorPacote);
	
	-- pegando o id da venda recém-criada
    set vIdVenda = 1;
    -- inserindo na nota fiscal
       insert into tbNotaFiscal (IdVenda)
    values (vIdVenda);
end  $$
delimiter ;
*/

select p.IdPassagem, p.Assento, p.Valor as ValorPassagem, p.Situacao,
       pac.NomePacote, pac.Valor as ValorPacote
from tbPassagem p
left join tbPacote pac on p.IdPassagem = pac.IdPassagem;

select pac.IdPacote, pac.NomePacote, prod.NomeProduto, prod.Valor as ValorProduto
from tbPacote pac
inner join tbProduto prod on pac.IdProduto = prod.IdProduto;

/* c.nome as Nome, p.nomePacote as NomePacote
from tbCliente c
inner join tbVenda v on c.IdCliente = v.IdCliente
inner join tbFuncionario f on f.IdFuncionario = f.IdFuncionario
inner join tbNotaFiscal NF on v.IdVenda = NF.IdVenda
inner join tbPacote p on NF.IdPacote = p.IdPacote;
*/

-- triggers
delimiter $$
create trigger updateCliente
after update on tbCliente
for each row
begin
	  insert into tbLogs (Usuario, DataLog, Acao)
    values (current_user(), now(), concat('Cliente atualizado: ID ', old.IdCliente, 
           ' | Nome antigo: ', old.Nome, ' → Novo nome: ', new.Nome));
end $$
delimiter ;
update tbCliente 
set Nome = 'João Silva Oliveira', 
    Email = 'joao.novo@email.com'
where IdCliente = 1;  -- Alterando os dados do cliente com ID 1

-- trigger exclusão
delimiter $$
create trigger deleteCliente
before delete on tbCliente
	for each row
		begin
        insert into tbLogs(Usuario, DataLog, Acao) values (current_user(), now(),  concat('Cliente excluído: ID ', old.IdCliente, ' - Nome: ', old.Nome));
        end $$
delimiter ;
delete from tbCliente where IdCliente = 1;