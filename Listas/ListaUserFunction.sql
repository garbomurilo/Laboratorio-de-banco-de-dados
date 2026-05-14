-- Exercicio 1
CREATE OR REPLACE FUNCTION FN_verHora (p_data IN DATE)
RETURN VARCHAR2 IS
BEGIN
    RETURN TO_CHAR(p_data, 'dd/mm/yyyy:HH24:mi:ss');
END;
/

-- Exercicio 2
CREATE OR REPLACE FUNCTION FN_VerificaIdoso (p_id_paciente IN NUMBER)
RETURN VARCHAR2 IS
    v_idade NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12)
    INTO v_idade
    FROM Paciente
    WHERE id_paciente = p_id_paciente;

    IF v_idade > 65 THEN
        RETURN 'IDOSO';
    ELSE
        RETURN 'NÃO IDOSO';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'ERRO: Paciente não encontrado.';
END;
/

-- Exercicio 3
ALTER TABLE Produto ADD QTDE_estoque NUMBER;

CREATE OR REPLACE FUNCTION FN_ConsultaEstoque (p_id_produto IN NUMBER)
RETURN NUMBER IS
    v_qtde NUMBER;
BEGIN
    SELECT QTDE_estoque
    INTO v_qtde
    FROM Produto
    WHERE id_produto = p_id_produto;

    RETURN v_qtde;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

SELECT FN_ConsultaEstoque(10) AS quantidade_atual FROM DUAL;

-- Exercicio 4
CREATE OR REPLACE FUNCTION FN_FormataTelefone (p_numero IN VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
    IF LENGTH(p_numero) = 10 THEN
        RETURN '(' || SUBSTR(p_numero, 1, 2) || ')' || 
               SUBSTR(p_numero, 3, 4) || '-' || 
               SUBSTR(p_numero, 7, 4);
    ELSIF LENGTH(p_numero) = 11 THEN
        RETURN '(' || SUBSTR(p_numero, 1, 2) || ')' || 
               SUBSTR(p_numero, 3, 5) || '-' || 
               SUBSTR(p_numero, 8, 4);
    ELSE
        RETURN p_numero;
    END IF;
END;
/

-- Exercicio 5
CREATE OR REPLACE FUNCTION FN_StatusCliente (p_id_cliente IN NUMBER)
RETURN VARCHAR2 IS
    v_nome_cliente VARCHAR2(100);
    v_qtd_pedidos NUMBER;
BEGIN
    SELECT nome INTO v_nome_cliente
    FROM Cliente
    WHERE id_cliente = p_id_cliente;

    SELECT COUNT(*)
    INTO v_qtd_pedidos
    FROM Pedido
    WHERE id_cliente = p_id_cliente;

    IF v_qtd_pedidos > 3 THEN
        RETURN 'Cliente preferencial - ' || p_id_cliente || ' - ' || v_nome_cliente;
    ELSIF v_qtd_pedidos BETWEEN 1 AND 3 THEN
        RETURN 'Cliente Normal - ' || p_id_cliente || ' - ' || v_nome_cliente;
    ELSE
        RETURN 'Cliente Inativo - ' || p_id_cliente || ' - ' || v_nome_cliente;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'ERRO: O código de cliente informado não existe no banco de dados.';
END;
/
