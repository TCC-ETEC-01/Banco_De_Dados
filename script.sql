 -- drop database dbAnu;
create database dbAnu;
use dbAnu;
show tables;

create table tbCliente (
  Nome varchar(50) not null,
  Sexo char(12),
  Email varchar(50) not null,
  Telefone char(11) not null,
  Cpf char(11) not null,
  IdCliente int auto_increment primary key
);

create table tbFuncionario (
  Nome varchar(50) not null,
  Sexo char(12) not null,
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
  Valor decimal(8,2) not null,
  Descricao Text not null,
  Quantidade int not null
);

create table tbPacote (
  IdPacote int auto_increment primary key,
  IdProduto int not null,
  IdPassagem int not null,
  NomePacote varchar(50) not null,
  Descricao text not null,
  Valor decimal(8,2) not null
);

create table tbViagem (
  IdViagem int auto_increment primary key,
  DataRetorno datetime not null,
  Descricao text not null,
  Origem varchar(200) not null,
  Destino varchar(200) not null,
  DataPartida datetime not null
);

create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento char(5) not null,
  Valor decimal(8,2) not null,
  DataCompra  timestamp default current_timestamp not null,
  IdViagem int not null,
  IdTransporte int not null,
  IdCliente int,
  Translado enum('Sim', 'Não') not null,
  Situacao varchar(50)
);

create table tbLogs(
	Usuario varchar(50) not null,
    DataLog timestamp default current_timestamp not null,
    Acao Text not null
);
create table tbVendaDetalhe(
	IdVenda int not null,
    IdPassagem int not null
);

create table tbVenda(
	IdVenda int primary key auto_increment,
    DataVenda timestamp default current_timestamp not null,
	IdPassagem int not null,
    Valor decimal(8,2) not null,
    IdCliente int not null,
    IdFuncionario int not null
);

create table tbTransporte(
	IdTransporte int primary key auto_increment,
	TipoTransporte enum('Ônibus', 'Avião') not null,
    CodigoTransporte char(5) not null,
	Companhia varchar(100) not null
);


-- criando foreign keys via alter table
alter table tbPassagem
add constraint FkViagem foreign key (IdViagem) references tbViagem(IdViagem),
add constraint FkPassagemCliente foreign key (IdCliente) references tbCliente(IdCliente),
add constraint FkTransporte foreign key(IdTransporte) references tbTransporte(IdTransporte);

alter table tbPacote 
add constraint FkPassagemPacote foreign key(IdPassagem) references tbPassagem(IdPassagem),
add constraint FkProdutoPacote foreign key(IdProduto) references tbProduto(IdProduto);

alter table tbVenda
add constraint FkIdPassagem foreign key(IdPassagem) references tbPassagem(IdPassagem),
add constraint FkIdCliente foreign key (IdCliente) references tbCliente(IdCliente),
add constraint FkIdFuncionario foreign key(IdFuncionario) references tbFuncionario(IdFuncionario);

alter table tbVendaDetalhe
add constraint FkIdVenda foreign key(IdVenda) references tbVenda(IdVenda),
add constraint FkIdPassagemVenda foreign key (IdPassagem) references tbPassagem(IdPassagem);


-- inserts
-- insert cliente
insert into tbCliente (Nome, Sexo, Email, Telefone, Cpf) values
('Ana Silva', 'F', 'ana@gmail.com', '11987654321', '12345678901'),
('Carlos Souza', 'M', 'carlos@hotmail.com', '21987654321', '23456789012'),
('Beatriz Costa', 'F', 'bea@yahoo.com', '11911223344', '34567890123'),
('Diego Ramos', 'M', 'diego@outlook.com', '11955667788', '45678901234');
  
-- insert funcionario
insert into tbFuncionario (Nome, Sexo, Email, Telefone, Cargo, Cpf, Senha) values
('João Pedro', 'M', 'joao@empresa.com', '31987654321', 'Atendente', '56789012345', 'abc12345'),
('Mariana Lima', 'F', 'mariana@empresa.com', '41987654321', 'Gerente', '67890123456', 'def67890'),
('Rafael Torres', 'M', 'rafa@empresa.com', '51987654321', 'Consultor', '78901234567', 'ghi45678'),
('Larissa Mendes', 'F', 'larissa@empresa.com', '61987654321', 'Vendedora', '89012345678', 'jkl98765');

-- insert produto
insert into tbProduto (NomeProduto, Valor, Descricao, Quantidade) values
('Passeio de Lancha', 299.99, 'Passeio de lancha de 2 horas', 10),
('Trilha na Mata', 150.00, 'Trilha com guia turístico', 25),
('Mergulho com Cilindro', 400.00, 'Experiência de mergulho com instrutor', 5),
('Tour Gastronômico', 180.00, 'Visita a restaurantes típicos com guia', 15);

-- selects
select * from tbPassagem;
select * from tbProduto;
select * from tbPacote;
select * from tbCliente;
select * from tbFuncionario;
select * from tbViagem;
select * from tbLogs;

-- procedures
-- verificando situação da passagem
delimiter $$
create procedure SituacaoPassagem(
in p_Id int 
)
	begin
		select * from tbPassagem
        where IdCliente is null and Situacao = 'Disponivel';
    end $$
    delimiter ;
call SituacaoPassagem(0);

-- deletando cliente que tem passagem
delimiter $$
create procedure DeletarClientePassagem(
	in p_IdCliente int
)
begin
	update tbPassagem
	set IdCliente = null
	where IdCliente = p_IdCliente;
    
	insert into tbLogs (Usuario, DataLog, Acao)
	values (
		current_user(), 
		now(), 
		concat('Cliente excluído via: ID ', p_IdCliente)
	);

	delete from tbCliente
	where IdCliente = p_IdCliente;
end $$
delimiter ;
	call DeletarClientePassagem(1);
    
-- deletando passagem que tem pacote
delimiter $$
create procedure DeletarPassagemPacote(
	in p_IdPassagem int,
	in p_IdPacote int
)
begin
	insert into tbLogs (Usuario, DataLog, Acao)
	values (
		current_user(), 
		now(), 
		concat('Exclusão de passagem: Passagem ID ', p_IdPassagem, ', Pacote ID ', p_IdPacote)
	);

	delete from tbPacote
	where IdPacote = p_IdPacote;

	delete from tbPassagem
	where IdPassagem = p_IdPassagem;
end $$
delimiter ;

-- deletando produto que tem pacote
delimiter $$
create procedure DeletarProdutoPacote(
	in p_IdProduto int,
	in p_IdPacote int
)
begin
	insert into tbLogs (Usuario, DataLog, Acao)
	values (
		current_user(), 
		now(), 
		concat('Exclusão de produto: Produto ID ', p_IdProduto, ', Pacote ID ', p_IdPacote)
	);

	delete from tbPacote
	where IdPacote = p_IdPacote;

	delete from tbProduto
	where IdProduto = p_IdProduto;
end $$
delimiter ;

-- insert viagem
delimiter $$
create procedure InserirViagem(
	p_DataPartida varchar(50),
    p_DataRetorno varchar(50),
    p_Origem varchar(200),
    p_Descricao varchar(200),
    p_Destino varchar(200)
)
begin
	insert into tbViagem(DataPartida,DataRetorno, Descricao, Origem, Destino)
	values(str_to_date(p_DataPartida,'%d/%m/%Y %H:%i:%s'), 
    str_to_date(p_DataRetorno, '%d/%m/%Y %H:%i:%s'),
    p_Descricao, 
    p_Origem, 
    p_Destino
);
end $$
delimiter ;
call InserirViagem(
    '18/07/2025 08:00:00',
    '20/07/2025 18:00:00',
    'São Paulo',
    'Viagem ao litoral com paradas em praias.',
    'Ubatuba'
);

call InserirViagem(
    '05/08/2025 10:30:00',
    '10/08/2025 22:00:00',
    'Rio de Janeiro', 'Pacote aéreo para o nordeste brasileiro.', 'Salvador'
);

call InserirViagem(
    '10/09/2025 06:00:00',
    '15/09/2025 21:00:00', 
    'Belo Horizonte', 'Excursão para trilhas ecológicas.', 'Chapada dos veadeiros'
);

call InserirViagem(
    '28/11/2025 09:00:00',
    '01/12/2025 20:00:00',
    'Curitiba','Viagem de fim de ano com festas e passeios.','Florianópolis'
);

-- insert transporte
delimiter $$
create procedure InserirTransporte(
	in p_TipoTransporte enum('Avião', 'Ônibus'),
    in p_CodigoTransporte char(5),
    in p_Companhia varchar(100)
)
begin	
			insert into tbTransporte(TipoTransporte, CodigoTransporte, Companhia)
			values(p_TipoTransporte, p_CodigoTransporte, p_Companhia);
end $$
delimiter ;
call InserirTransporte('Ônibus', 123,'Gol');
call InserirTransporte('Avião', 1234,'Latam');
call InserirTransporte('Ônibus', 12,'Cometa');
call InserirTransporte('Avião', 12345,'Azul');
call InserirTransporte('Ônibus', 053, 'EMTU');
call InserirTransporte('Avião', '123A','Azul');

-- insert passagem
delimiter $$
create procedure InserirPassagem(
	in p_Assento char(5),
    in p_Valor decimal(8,2),
    in p_IdViagem int,
    in p_Situacao varchar(50),
    in p_Translado enum('Sim', 'Não'),
    in p_IdTransporte int
)
begin	
		if exists(select 1 from tbViagem where IdViagem = p_IdViagem) then
			insert into tbPassagem(Assento, Valor, IdViagem,Situacao, Translado, IdTransporte)
			values(p_Assento, p_Valor,p_IdViagem, p_Situacao,p_Translado, p_IdTransporte);
		end if;
end $$
delimiter ;
call InserirPassagem('5D', 250.00, 4,'Disponivel', 'Sim', 1);
call InserirPassagem('12A', 180.00, 1, 'Disponivel', 'Não', 2);
call InserirPassagem('7C', 450.00, 2, 'Disponivel', 'Sim', 3);
call InserirPassagem('18B', 300.00,3, 'Disponivel', 'Não', 4);
call InserirPassagem('5D', 250.00, 4, 'Disponivel', 'Sim', 5);
call InserirPassagem('11A' ,300, 5, 'Disponivel', 'Sim', 6);

-- insert pacote
delimiter $$
 create procedure InserirPacote(
    in p_IdProduto int,
    in p_IdPassagem int, 
    in p_NomePacote varchar(50),
    in p_Descricao text,
    in p_Valor decimal(8,2)
 )
begin
	if exists(select 1 from tbProduto where IdProduto = p_IdProduto)
		and exists(select 1 from tbPassagem where IdPassagem = p_IdPassagem) then
			insert into tbPacote(IdProduto, IdPassagem, NomePacote, Descricao, Valor)
					values(p_IdProduto, p_IdPassagem, p_NomePacote, p_Descricao, p_Valor);
	end if;
end $$
delimiter ;
call InserirPacote(1, 1, 'Pacote Litoral Plus', 'Inclui passeio de lancha e transporte ida e volta.', 479.99);
call InserirPacote(2, 2, 'Pacote Trilha Nordeste', 'Inclui trilha e transporte aéreo.', 599.99);
call InserirPacote(3, 3, 'Pacote Mergulho Top', 'Mergulho com cilindro + hospedagem.', 699.99);
call InserirPacote(4, 4, 'Pacote Gourmet Sul', 'Tour gastronômico e transporte.', 420.00);
 
 -- operação de compra
 /*
 -- compra de pacote
delimiter $$
create procedure ComprarPacote(
    in p_IdPacote int, 
    in p_IdCliente int
)
begin
    declare vValorPacote decimal(8,2);
    declare vIdVenda int;
    declare vIdFuncionario int default 1;
	declare vNomePacote varchar(50);
    declare vIdPassagem int;

    -- Verifica se o pacote existe
    if exists (select 1 from tbPacote where IdPacote = p_IdPacote) then
        -- Busca os dados do pacote
        select IdPacote, Valor, IdPassagem
        into p_IdPacote, vValorPacote, vIdPassagem
        from tbPacote
        where IdPacote = p_IdPacote
        limit 1;

        -- Verifica se IdPassagem não é nulo antes de tentar inserir
        if p_IdPacote is not null then
            insert into tbVenda (IdCliente, IdFuncionario, DataVenda, Valor, IdPassagem)
            values (p_IdCliente, vIdFuncionario, now(), vValorPacote, vIdPassagem);

            set vIdVenda = last_insert_id();

            insert into tbVendaDetalhe (IdVenda)
            values (vIdVenda);
        else
            signal sqlstate '45000'
            set message_text = 'Pacote encontrado, mas IdPassagem está nulo.';
        end if;
    else
        signal sqlstate '45000'
        set message_text = 'Pacote não encontrado.';
    end if;

end $$
delimiter ;
drop procedure ComprarPacote;
call ComprarPacote(4, 4);
*/

-- compra de passagem
delimiter $$
create procedure ComprarPassagem(
    in p_IdPassagem int, 
    in p_IdCliente int 
)
begin
    declare vValorPassagem decimal(8,2);
    declare vIdVenda int;
    declare vIdFuncionario int default 1;
	
    if exists(select * from tbPassagem where IdPassagem = p_IdPassagem) then
    select Valor
    into vValorPassagem
    from tbPassagem
    where IdPassagem = p_IdPassagem
   limit 1;
    
    insert into tbVenda (IdCliente, IdFuncionario, DataVenda, Valor, IdPassagem)
    values (p_IdCliente, vIdFuncionario, now(), vValorPassagem, p_IdPassagem);
    
    set vIdVenda = last_insert_id();

    insert into tbVendaDetalhe (IdVenda)
    values (vIdVenda);

    update tbPassagem
    set Situacao = 'Indisponivel', IdCliente = IdCliente
    where IdPassagem = p_IdPassagem;
end if;
end $$
delimiter ;
call ComprarPassagem(6,1);

-- inner joins
select c.IdCliente, c.Nome as Nome, c.Email,
p.IdPassagem, p.Assento, p.Valor, p.Situacao
from tbPassagem p
inner join tbCliente c on p.IdCliente = c.IdCliente;
    
select pac.IdPacote, pac.NomePacote,  prod.NomeProduto,p.Assento as Assento, p.Situacao as Situacao, p.Translado,  t.TipoTransporte as Transporte, t.Companhia, t.CodigoTransporte as Cod_Transporte
from tbPacote pac
inner join tbProduto prod on pac.IdProduto = prod.IdProduto
inner join tbPassagem p on pac.IdPassagem = p.IdPassagem
inner join tbTransporte t on p.IdTransporte = t.IdTransporte;

select  p.IdPassagem,v.Origem, v.Destino, p.Assento,v.Descricao, v.DataPartida as Partida, v.DataRetorno as Retorno, t.TipoTransporte as Transporte, t.Companhia, t.CodigoTransporte as Cod_Transporte
from tbPassagem p
inner join tbViagem v on p.IdViagem = v.IdViagem
inner join tbTransporte t on p.IdTransporte = t.IdTransporte;