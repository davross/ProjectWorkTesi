-- ======================================
-- Query per l'estrazione
-- ======================================

-- query per l'estrazione degli asset critici, ovvero con valore di criticita maggiore di 2 quindi rischio alto e critico
SELECT
    a.id_asset,
    a.nome,
    a.categoria,
    a.esposizione_internet,
    a.valore_criticita_intrinseca,
    a.stato
FROM asset a
WHERE a.data_fine_validita IS NULL
  AND a.valore_criticita_intrinseca > 2;


-- query per l'estrazione dei servizi
SELECT
    s.nome AS servizio,
    s.categoria AS categoria_servizio,
    s.livello_criticita,
    a.nome AS asset_supporto,
    a.categoria AS categoria_asset,
    asv.tipo_dipendenza
FROM servizio s
JOIN asset_servizio asv ON s.id_servizio = asv.id_servizio
JOIN asset a ON a.id_asset = asv.id_asset
WHERE s.data_fine_validita IS NULL
  AND asv.data_fine_validita IS NULL
  AND a.data_fine_validita IS NULL;


-- query per l'estrazione dei fornitori 
SELECT
    s.nome AS servizio,
    f.nome AS fornitore,
    f.tipo,
    sf.ruolo
FROM servizio s
JOIN servizio_fornitore sf ON s.id_servizio = sf.id_servizio
JOIN fornitore f ON f.id_fornitore = sf.id_fornitore
WHERE s.data_fine_validita IS NULL
  AND sf.data_fine_validita IS NULL
  AND f.data_fine_validita IS NULL;


-- query per l'estrazione dei resposabili con contatti
SELECT
    r.owner,
    r.email,
    r.ruolo,
    re.tipo_entita,
    re.id_entita,
    re.ruolo_responsabile,
    re.ruolo_responsabilita
FROM responsabilita_entity re
JOIN responsabili r ON r.id_responsabile = re.id_responsabile
WHERE re.data_fine_validita IS NULL;



-- ======================================
-- View per estrazione conforme al profilo ACN con export in csv
-- ======================================


-- Creo la view 
CREATE OR REPLACE VIEW v_profilo_acn_export AS
SELECT
    a.nome              AS asset,
    a.categoria         AS categoria_asset,
    a.esposizione_internet,
    a.valore_criticita_intrinseca,
    s.nome              AS servizio,
    s.livello_criticita AS criticita_servizio,
    f.nome              AS fornitore,
    sf.ruolo            AS ruolo_fornitore,
    r.owner             AS responsabile,
    r.email              AS contatto,
    re.ruolo_responsabile
FROM asset a
LEFT JOIN asset_servizio asv ON a.id_asset = asv.id_asset
LEFT JOIN servizio s ON s.id_servizio = asv.id_servizio
LEFT JOIN servizio_fornitore sf ON s.id_servizio = sf.id_servizio
LEFT JOIN fornitore f ON f.id_fornitore = sf.id_fornitore
LEFT JOIN responsabilita_entity re
       ON re.tipo_entita = 'asset'
      AND re.id_entita = a.id_asset
LEFT JOIN responsabili r ON r.id_responsabile = re.id_responsabile
WHERE a.data_fine_validita IS NULL
  AND (asv.data_fine_validita IS NULL OR asv.id_asset IS NULL)
  AND (s.data_fine_validita IS NULL OR s.id_servizio IS NULL);

-- Esporto in formato csv
COPY (
    SELECT * FROM v_profilo_acn_export
) TO '/tmp/estrazione_profilo_acn.csv'
DELIMITER ','
CSV HEADER;


-- ======================================
-- Query per testare i trigger
-- ======================================

-- ASSET: aggiorno firewall
UPDATE asset
SET nome = 'new firewall'
WHERE id_asset = 6
  AND data_fine_validita IS NULL;

-- SERVIZIO: aggiorno Backup Database
UPDATE servizio
SET nome = 'new backup database'
WHERE id_servizio = 3
  AND data_fine_validita IS NULL;

-- ASSET_SERVIZIO: aggiorto tipo dipendeza del servizio
UPDATE asset_servizio
SET tipo_dipendenza = 'new dipendenza'
WHERE id_asset_servizio = 4
  AND data_fine_validita IS NULL;

-- SERVIZIO_FORNITORE: aggiorno nuovo ruolo 
UPDATE servizio_fornitore
SET ruolo = 'new ruolo'
WHERE id_servizio_fornitore = 1
  AND data_fine_validita IS NULL;

-- RESPONSABILITA_ENTITY: aggiorno nuona responsabilita
UPDATE responsabilita_entity
SET ruolo_responsabilita = 'new responsabilita'
WHERE id_resp_entity = 2
  AND data_fine_validita IS NULL;

-- FORNITORE: aggiorno CloudProvider
UPDATE fornitore
SET nome = 'new CloudProvider'
WHERE id_fornitore = 2
  AND data_fine_validita IS NULL;

-- RESPONSABILI: aggiorno Maria Bianchi
UPDATE responsabili
SET owner = 'new Maria Bianchi'
WHERE id_responsabile = 2;