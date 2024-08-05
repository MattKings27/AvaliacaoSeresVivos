-- SELECTS e MANIPULATION --

SELECT e.nome_cientifico, e.nome_comum
FROM especie e
INNER JOIN observacao o on e.id = o.especie_id
INNER JOIN localizacao l ON o.localizacao_id = l.id
INNER JOIN habitat h ON l.id = h.id
WHERE h.descricao ilike '%Floresta Amazônica'
AND e.tipo ILIKE '%Ave'
AND e.migratoria = TRUE;

SELECT l.descricao AS area_protegida, COUNT(o.id) / ST_Area(l.coordenadas) AS densidade_populacional
FROM especie e
INNER JOIN observacao o ON e.id = o.especie_id
INNER JOIN localizacao l ON o.localizacao_id = l.id
INNER JOIN habitat h ON l.id = h.id
WHERE e.nome_comum ILIKE '%Onça-pintada'
AND l.area_protegida = TRUE
AND h.descricao ILIKE '%Cerrado'
GROUP BY l.descricao, l.coordenadas;


SELECT e.nome_cientifico, e.nome_comum
FROM especie e
INNER JOIN habitat h ON e.id = h.id
INNER JOIN localizacao l ON h.id = l.id
WHERE h.descricao ilike '%Mata Atlântica'
AND e.endemica = TRUE
AND e.status_conservacao ilike '%Ameaçada';


SELECT d.nome AS doenca
FROM doenca d
INNER JOIN especie_doenca ed ON d.id = ed.doenca_id
INNER JOIN especie e ON ed.especie_id = e.id
INNER JOIN observacao o ON e.id = o.especie_id
INNER JOIN localizacao l on o.localizacao_id = l.id
WHERE e.filo ilike '%Primata'
AND l.area_desmatada = TRUE;


SELECT d.nome as doenca, 
       COUNT(CASE when o.morte = TRUE THEN 1 END) * 100.0 / COUNT(o.id) as taxa_mortalidade
FROM doenca d
INNER JOIN especie_doenca ed ON d.id = ed.doenca_id
INNER JOIN especie e ON ed.especie_id = e.id
INNER JOIN observacao o on e.id = o.especie_id
WHERE e.nome_cientifico = 'Nome Científico da Espécie'
GROUP BY d.nome;


SELECT g.nome AS genero, COUNT(e.id) AS quantidade_especies
FROM genero g
INNER JOIN especie e ON g.id = e.genero_id
INNER JOIN familia f ON g.familia_id = f.id
WHERE f.nome ILIKE '%Felidae'
GROUP BY g.nome
ORDER BY quantidade_especies DESC;



SELECT EXTRACT(YEAR FROM o.data_hora) AS ano, 
       COUNT(o.id) AS populacao
FROM observacao o
INNER JOIN especie e ON o.especie_id = e.id
WHERE e.nome_cientifico = 'Nome Científico da Espécie'
GROUP BY ano
ORDER BY ano;



SELECT l.descricao AS area_prioritaria, 
       ST_Area(l.coordenadas) AS area_tamanho
FROM localizacao l
INNER JOIN observacao o ON l.id = o.localizacao_id
INNER JOIN especie e ON o.especie_id = e.id
WHERE e.nome_cientifico = 'Nome Científico da Espécie'
AND l.area_protegida = TRUE
ORDER BY area_tamanho DESC;


SELECT * FROM especies_coexistentes_interacoes('Pterois volitans');
SELECT * FROM taxa_declinio_populacional;


