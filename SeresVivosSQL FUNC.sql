-- Funcionalidades

SELECT e.nome_cientifico, l.descricao, l.coordenadas
FROM especie e
INNER JOIN observacao o ON e.id = o.especie_id
INNER JOIN localizacao l ON o.localizacao_id = l.id;



SELECT h.descricao AS habitat, COUNT(e.id) AS riqueza_especies
FROM habitat h
INNER JOIN especie_habitat eh ON h.id = eh.habitat_id
INNER JOIN especie e ON eh.especie_id = e.id
GROUP BY h.descricao;



SELECT e.nome_cientifico, d.nome
FROM especie e
INNER JOIN especie_doenca ed ON e.id = ed.especie_id
INNER JOIN doenca d ON ed.doenca_id = d.id
WHERE e.nome_cientifico = 'Nome Científico da Espécie';



CREATE OR REPLACE FUNCTION diversidade_especies(area GEOMETRY)
RETURNS INT AS $$
DECLARE
  qtd_especies INT;
BEGIN
  SELECT COUNT(DISTINCT e.id)
  INTO qtd_especies
  FROM especie e
  INNER JOIN observacao o ON e.id = o.especie_id
  INNER JOIN localizacao l ON o.localizacao_id = l.id
  WHERE ST_Within(l.coordenadas, area);
  RETURN qtd_especies;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION calcular_distancia(ponto1 GEOMETRY, ponto2 GEOMETRY)
RETURNS FLOAT AS $$
BEGIN
  RETURN ST_Distance(ponto1, ponto2);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION atualizar_status_conservacao()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT COUNT(*) FROM observacao o WHERE o.especie_id = NEW.especie_id) < 10 THEN
    UPDATE especie SET status_conservacao = 'Em Perigo' WHERE id = NEW.especie_id;
  ELSE
    UPDATE especie SET status_conservacao = 'Segura' WHERE id = NEW.especie_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_atualizar_status
AFTER INSERT OR UPDATE ON observacao
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_conservacao();



CREATE TABLE historico_alteracoes (
  id SERIAL PRIMARY KEY,
  tabela_nome VARCHAR,
  registro_id INT,
  data_hora TIMESTAMP,
  alteracao TEXT
);



CREATE OR REPLACE FUNCTION registrar_historico()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO historico_alteracoes (tabela_nome, registro_id, data_hora, alteracao)
  VALUES (TG_TABLE_NAME, NEW.id, NOW(), 'Registro atualizado');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_registrar_historico
AFTER INSERT OR UPDATE OR DELETE ON especie
FOR EACH ROW
EXECUTE FUNCTION registrar_historico();

CREATE VIEW especies_endemicas AS
SELECT e.nome_cientifico, l.descricao
FROM especie e
INNER JOIN observacao o ON e.id = o.especie_id
INNER JOIN localizacao l ON o.localizacao_id = l.id
WHERE l.descricao = 'Nome do País';



CREATE VIEW riqueza_especies_bioma AS
SELECT h.descricao AS bioma, COUNT(e.id) AS quantidade_especies
FROM habitat h
INNER JOIN especie_habitat eh ON h.id = eh.habitat_id
INNER JOIN especie e ON eh.especie_id = e.id
GROUP BY h.descricao;


