USE bdConfeitariaSonho;

-- A)
ALTER PROCEDURE spCategoriaProduto
	@nomeCategoriaProduto VARCHAR(40)
AS
BEGIN 
	INSERT INTO tbCategoriaProduto (nomeCategoriaProduto)
	VALUES (@nomeCategoriaProduto);
	 PRINT 'Categoria de produto ' + @nomeCategoriaProduto + ' inserida com sucesso';
END;
EXEC spCategoriaProduto 'Bolo Festa';
EXEC spCategoriaProduto 'Bolo Simples';
EXEC spCategoriaProduto 'Torta';
EXEC spCategoriaProduto 'Salgado';
SELECT * FROM tbCategoriaProduto;

-- B)
ALTER PROCEDURE spInsereProduto
    @nomeProduto VARCHAR(40),
    @precoKiloProduto SMALLINT,
    @codCategoriaProduto INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tbProduto WHERE nomeProduto = @nomeProduto)
    BEGIN
        INSERT INTO tbProduto (nomeProduto, precoKiloProduto, codCategoriaProduto)
        VALUES (@nomeProduto, @precoKiloProduto, @codCategoriaProduto);

		PRINT 'Produto ' + @nomeProduto + ' cadastrado com sucesso';

    END;
END;

-- Executando a stored procedure com os valores desejados
EXEC spInsereProduto 'Bolo Floresta Negra', 42.00, 1;
EXEC spInsereProduto 'Bolo Prestígio', 43.00, 1;
EXEC spInsereProduto 'Bolo Nutella', 44.00, 1;
EXEC spInsereProduto 'Bolo Formigueiro', 17.00, 2;
EXEC spInsereProduto 'Bolo de cenoura', 19.00, 2;
EXEC spInsereProduto 'Torta de palmito', 45.00, 3;
EXEC spInsereProduto 'Torta de frango e catupiry', 47.00, 3;
EXEC spInsereProduto 'Torta de escarola', 44.00, 3;
EXEC spInsereProduto 'Coxinha frango', 25.00, 4;
EXEC spInsereProduto 'Esfiha carne', 27.00, 4;
EXEC spInsereProduto 'Folhado queijo', 31.00, 4;
EXEC spInsereProduto 'Risoles misto', 29.00, 4;


SELECT*FROM tbProduto;





	

-- C)
ALTER PROCEDURE spCadastrarClienteComValidacao
    @nomeCliente VARCHAR(40),
    @dataNascimentoCliente DATE,
    @ruaCliente VARCHAR(40),
    @numCasaCliente INT,
    @cepCliente VARCHAR(12),
    @cpfCliente VARCHAR(11),
    @bairroCliente VARCHAR(40),
    @sexoCliente VARCHAR(8)
AS
BEGIN
    -- Verifica se o cliente já está cadastrado pelo CPF
    IF EXISTS (SELECT 1 FROM tbCliente WHERE cpfCliente = @cpfCliente)
    BEGIN
        PRINT 'Cliente cpf ' + @cpfCliente + ' já cadastrado';
        RETURN;
    END;

    -- Verifica se o cliente é morador de Itaquera ou Guaianases
    IF @bairroCliente NOT IN ('Itaquera', 'Guaianases')
    BEGIN
        PRINT 'Não foi possível cadastrar o cliente ' + @nomeCliente + ' pois o bairro ' + @bairroCliente + ' não é atendido pela confeitaria';
        RETURN;
    END;

    -- Insere o cliente
    INSERT INTO tbCliente (nomeCliente, dataNascimentoCliente, ruaCliente, numCasaCliente, cpfCliente, cepCliente, bairroCliente, sexoCliente)
    VALUES (@nomeCliente,  @dataNascimentoCliente, @ruaCliente, @numCasaCliente, @cpfCliente, @cepCliente, @bairroCliente, @sexoCliente);

    PRINT 'Cliente ' + @nomeCliente + ' cadastrado com sucesso';
END;


EXEC spCadastrarClienteComValidacao 'Samira Fatah', '1990-05-15', 'Rua Agapeí', 123, '08090000', '12345678901', 'Guaianases', 'F';
EXEC spCadastrarClienteComValidacao 'Celia Nogueira', '1992-06-06', 'Rua Andes', 456, '08456090', '55555555555', 'Guaianases', 'F';
EXEC spCadastrarClienteComValidacao 'Paulo Cesar Nogueira', '1984-04-04', 'Rua Castelo do Piauí', 789, '08109000', '99999999999', 'Itaquera', 'M';
EXEC spCadastrarClienteComValidacao 'Rodrigo Favaroni', '1991-04-09', 'Rua Sansão Castelo Branco', 789, '084310900', '88888888888','Guaianases', 'M';
EXEC spCadastrarClienteComValidacao 'Flávia Regina Brito', '1992-04-22', 'Rua Mariano Moro', 300,'08200123', '77777777777','Itaquera','F';

SELECT * FROM tbCliente;



-- D)
ALTER PROCEDURE spCriarEncomenda
    @cpfCliente VARCHAR(15)
AS
BEGIN
    DECLARE @codCliente INT, @nomeCliente VARCHAR(40);
    
    -- Verificar se o cliente existe pelo CPF
    SELECT @codCliente = codCliente, @nomeCliente = nomeCliente
    FROM tbCliente
    WHERE cpfCliente = @cpfCliente;
    
    IF @codCliente IS NULL
    BEGIN
        PRINT 'Não foi possível efetivar a encomenda pois o cliente ' + @cpfCliente + ' não está cadastrado';
        RETURN;
    END;

    -- Inserir a encomenda
    DECLARE @codEncomenda INT;
    INSERT INTO tbEncomenda (dataEncomenda, codCliente, valorTotalEncomenda, dataEntregaEncomenda)
    VALUES (GETDATE(), @codCliente, 100.00, '2023-09-15'); 
    
    SET @codEncomenda = SCOPE_IDENTITY();

    PRINT 'Encomenda ' + CAST(@codEncomenda AS VARCHAR) + ' para o cliente ' + @nomeCliente + ' efetuada com sucesso';
END;


EXEC spCriarEncomenda '12345678901';
EXEC spCriarEncomenda '55555555555';
EXEC spCriarEncomenda '99999999999';
EXEC spCriarEncomenda '88888888888';
EXEC spCriarEncomenda '77777777777';

SELECT*FROM tbEncomenda;





-- E)
ALTER PROCEDURE spInserirItensEncomenda (
    @codEncomenda INT,
    @codProduto INT,
    @quantidadeKilos INT,
    @subTotal SMALLMONEY
)
AS
BEGIN
    INSERT INTO tbItensEncomenda ( codEncomenda, codProduto, quantitadeKilos, subTotal)
    VALUES ( @codEncomenda, @codProduto, @quantidadeKilos, @subTotal);
	PRINT 'Itens inseridos com sucesso!'
END;


EXEC spInserirItensEncomenda 1, 10, 2, 70.00;
EXEC spInserirItensEncomenda 2, 2, 3, 80.00;
EXEC spInserirItensEncomenda  1, 9, 6, 150.00;
EXEC spInserirItensEncomenda  1, 12, 4, 125.00;
EXEC spInserirItensEncomenda  2, 9, 8, 200.00;
EXEC spInserirItensEncomenda  3, 11, 2, 100.00;
EXEC spInserirItensEncomenda  3, 9, 2, 50.00;
EXEC spInserirItensEncomenda  4, 2, 3, 150.00;
EXEC spInserirItensEncomenda  4, 3, 2, 100.00;
EXEC spInserirItensEncomenda  4, 6, 3, 150.00;

SELECT*FROM tbItensEncomenda;





-- F)
ALTER PROCEDURE spAtualizarPrecos
AS
BEGIN
    -- 1 - Aumento de 10% nos produtos da categoria "Bolo festa"
    UPDATE tbProduto
    SET precoKiloProduto = precoKiloProduto * 1.10
    WHERE codCategoriaProduto = 1;

    -- 2 - Desconto de 20% nos produtos da categoria "Bolo simples"
    UPDATE tbProduto
    SET precoKiloProduto = precoKiloProduto * 0.80
    WHERE codCategoriaProduto = 2;

    -- 3 - Aumento de 25% nos produtos da categoria "Torta"
    UPDATE tbProduto
    SET precoKiloProduto = precoKiloProduto * 1.25
    WHERE codCategoriaProduto = 3;

    -- 4 - Aumento de 20% nos produtos da categoria "Salgado" (exceto esfiha de carne)
    UPDATE tbProduto
    SET precoKiloProduto = precoKiloProduto * 1.20
    WHERE codCategoriaProduto = 4 AND nomeProduto <> 'Esfiha de Carne';
END
EXEC spAtualizarPrecos;
SELECT * FROM tbProduto;







-- G)
ALTER PROCEDURE spExcluirClientePorCPF
    @cpfCliente VARCHAR(11)
AS
BEGIN
    DECLARE @clientePossuiEncomendas INT;

    -- Verifica se o cliente possui encomendas
    SELECT @clientePossuiEncomendas = COUNT(*)
    FROM tbEncomenda
    WHERE codCliente = (SELECT codCliente FROM tbCliente WHERE cpfCliente = @cpfCliente);

    IF @clientePossuiEncomendas > 0
    BEGIN
        DECLARE @errMsg VARCHAR(200);
        SET @errMsg = 'Impossível remover esse cliente pois o cliente ' + @cpfCliente + ' possui encomendas.';
        THROW 51000, @errMsg, 1;
    END
    ELSE
    BEGIN
        DELETE FROM tbCliente WHERE cpfCliente = @cpfCliente;
        PRINT 'Cliente ' + @cpfCliente + ' removido com sucesso';
    END
END;

EXEC spExcluirClientePorCPF '12345678901';

SELECT*FROM tbCliente;



-- H)
ALTER PROCEDURE spExcluirItemEncomenda
    @codEncomenda INT,
    @codProduto INT,
	@valorTotalEncomenda SMALLMONEY
AS
BEGIN
    DECLARE @valorItem SMALLMONEY;

    -- Obtém o valor do item a ser excluído
    SELECT @valorItem = @valorTotalEncomenda
    FROM tbItensEncomenda
    WHERE codEncomenda = @codEncomenda AND codProduto = @codProduto;

    -- Remove o item da encomenda
    DELETE FROM tbItensEncomenda
    WHERE codEncomenda = @codEncomenda AND codProduto = @codProduto;

    -- Atualiza o valor total da encomenda
    UPDATE tbEncomenda
    SET @valorTotalEncomenda = valorTotalEncomenda - @valorItem
    WHERE codEncomenda = @codEncomenda;

	PRINT'Lista atualizada!'
END;

EXEC spExcluirItemEncomenda 1, 10, 70.00;




-- I) 
ALTER PROCEDURE spExcluirEncomendaPorCPFData
    @cpfCliente VARCHAR(11),
    @dataEntregaEncomenda DATE
AS
BEGIN
    DECLARE @codCliente INT, @codEncomenda INT;

    -- Verifica se o cliente existe
    SELECT @codCliente = codCliente
    FROM tbCliente
    WHERE cpfCliente = @cpfCliente;

    IF @codCliente IS NULL
    BEGIN
        PRINT 'Cliente não encontrado';
        RETURN;
    END;

    -- Verifica se a encomenda existe
    SELECT @codEncomenda = codEncomenda
    FROM tbEncomenda
    WHERE codCliente = @codCliente AND dataEntregaEncomenda = @dataEntregaEncomenda;

    IF @codEncomenda IS NULL
    BEGIN
        PRINT 'Encomenda não encontrada para o cliente informado na data informada';
        RETURN;
    END;

    -- Exclui a encomenda e seus itens
    DELETE FROM tbItensEncomenda WHERE codEncomenda = @codEncomenda;
    DELETE FROM tbEncomenda WHERE codEncomenda = @codEncomenda;

    PRINT 'Encomenda removida com sucesso';
END

EXEC spExcluirEncomendaPorCPFData '12345678901', '2023-08-02';



-- J)
ALTER PROCEDURE spListarEncomendasPorDataEntrega
    @dataEntrega DATE
AS 
BEGIN
    SELECT 
        tbEncomenda.codEncomenda,
        tbCliente.nomeCliente,
        tbEncomenda.dataEntregaEncomenda,
        tbProduto.nomeProduto,
        tbItensEncomenda.quantitadeKilos
    FROM 
        tbEncomenda
    INNER JOIN 
        tbCliente ON tbEncomenda.codCliente = tbCliente.codCliente
    INNER JOIN 
        tbItensEncomenda ON tbEncomenda.codEncomenda = tbItensEncomenda.codEncomenda
    INNER JOIN 
        tbProduto ON tbItensEncomenda.codProduto = tbProduto.codProduto
    WHERE 
        tbEncomenda.dataEntregaEncomenda = @dataEntrega;
END;


EXEC spListarEncomendasPorDataEntrega '2023-08-30';	