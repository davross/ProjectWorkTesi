-- ======================================
-- TRIGGER - VERSIONING ASSET
-- ======================================

-- Rimozione preventiva del trigger se già esistente
DROP TRIGGER IF EXISTS trg_asset_update ON asset;

-- Funzione di versioning per la tabella asset
CREATE OR REPLACE FUNCTION asset_versioning_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Se non ci sono variazioni reali nei dati, consente l'UPDATE
    IF OLD IS NOT DISTINCT FROM NEW THEN
        RETURN NEW;
    END IF;

    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Chiusura della versione precedente
    UPDATE asset
    SET data_fine_validita = CURRENT_DATE
    WHERE id_asset = OLD.id_asset
      AND data_fine_validita IS NULL;

    -- Inserimento della nuova versione dell'asset
    INSERT INTO asset (
        nome,
        descrizione,
        categoria,
        esposizione_internet,
        impatto_confidenzialita,
        impatto_integrita,
        impatto_disponibilita,
        stato,
        data_inizio_validita,
        data_fine_validita
    )
    VALUES (
        NEW.nome,
        NEW.descrizione,
        NEW.categoria,
        NEW.esposizione_internet,
        NEW.impatto_confidenzialita,
        NEW.impatto_integrita,
        NEW.impatto_disponibilita,
        NEW.stato,
        CURRENT_DATE,
        NULL
    );
	
	RAISE NOTICE 'Update con chiusura del vecchio dato, andato a buon fine';

    -- Blocco dell'UPDATE originale
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Associazione del trigger alla tabella asset
CREATE TRIGGER trg_asset_update
BEFORE UPDATE ON asset
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION asset_versioning_trigger();


-- ======================================
-- TRIGGER - VERSIONING SERVIZIO
-- ======================================

-- Rimozione preventiva del trigger se già esistente
DROP TRIGGER IF EXISTS trg_servizio_update ON servizio;

-- Funzione di versioning per la tabella servizio
CREATE OR REPLACE FUNCTION servizio_versioning_trigger()
RETURNS TRIGGER AS $$
BEGIN
    
    IF OLD IS NOT DISTINCT FROM NEW THEN
        RETURN NEW;
    END IF;

    
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Chiusura della versione precedente
    UPDATE servizio
    SET data_fine_validita = CURRENT_DATE
    WHERE id_servizio = OLD.id_servizio
      AND data_fine_validita IS NULL;

    -- Inserimento della nuova versione del servizio
    INSERT INTO servizio (
        nome,
        descrizione,
        categoria,
        livello_criticita,
        data_inizio_validita,
        data_fine_validita
    )
    VALUES (
        NEW.nome,
        NEW.descrizione,
        NEW.categoria,
        NEW.livello_criticita,
        CURRENT_DATE,
        NULL
    );
	
	RAISE NOTICE 'Update con chiusura del vecchio dato, andato a buon fine';

    -- Blocco dell'UPDATE originale
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Associazione del trigger alla tabella servizio
CREATE TRIGGER trg_servizio_update
BEFORE UPDATE ON servizio
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION servizio_versioning_trigger();


-- ======================================
-- TRIGGER - VERSIONING ASSET_SERVIZIO
-- ======================================

-- Rimozione preventiva del trigger se già esistente
DROP TRIGGER IF EXISTS trg_asset_servizio_update ON asset_servizio;

-- Funzione di versioning per la tabella di relazione asset_servizio
CREATE OR REPLACE FUNCTION asset_servizio_versioning_trigger()
RETURNS TRIGGER AS $$
BEGIN
    
    IF OLD IS NOT DISTINCT FROM NEW THEN
        RETURN NEW;
    END IF;

 
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Chiusura della versione precedente della relazione
    UPDATE asset_servizio
    SET data_fine_validita = CURRENT_DATE
    WHERE id_asset_servizio = OLD.id_asset_servizio
      AND data_fine_validita IS NULL;

    -- Inserimento della nuova versione della relazione
    INSERT INTO asset_servizio (
        id_asset,
        id_servizio,
        tipo_dipendenza,
        data_inizio_validita,
        data_fine_validita
    )
    VALUES (
        NEW.id_asset,
        NEW.id_servizio,
        NEW.tipo_dipendenza,
        CURRENT_DATE,
        NULL
    );
	
	RAISE NOTICE 'Update con chiusura del vecchio dato, andato a buon fine';

    -- Blocco dell'UPDATE originale
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Associazione del trigger alla tabella asset_servizio
CREATE TRIGGER trg_asset_servizio_update
BEFORE UPDATE ON asset_servizio
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION asset_servizio_versioning_trigger();


-- ======================================
-- TRIGGER - VERSIONING SERVIZIO_FORNITORE
-- ======================================

-- Rimozione preventiva del trigger se già esistente
DROP TRIGGER IF EXISTS trg_servizio_fornitore_update ON servizio_fornitore;

-- Funzione di versioning per la tabella servizio_fornitore
CREATE OR REPLACE FUNCTION servizio_fornitore_versioning_trigger()
RETURNS TRIGGER AS $$
BEGIN
    
    IF OLD IS NOT DISTINCT FROM NEW THEN
        RETURN NEW;
    END IF;

    
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Chiusura della versione precedente della relazione
    UPDATE servizio_fornitore
    SET data_fine_validita = CURRENT_DATE
    WHERE id_servizio_fornitore = OLD.id_servizio_fornitore
      AND data_fine_validita IS NULL;

    -- Inserimento della nuova versione della relazione
    INSERT INTO servizio_fornitore (
        id_servizio,
        id_fornitore,
        ruolo,
        data_inizio_validita,
        data_fine_validita
    )
    VALUES (
        NEW.id_servizio,
        NEW.id_fornitore,
        NEW.ruolo,
        CURRENT_DATE,
        NULL
    );
	
	RAISE NOTICE 'Update con chiusura del vecchio dato, andato a buon fine';

    -- Blocco dell'UPDATE originale
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Associazione del trigger alla tabella servizio_fornitore
CREATE TRIGGER trg_servizio_fornitore_update
BEFORE UPDATE ON servizio_fornitore
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION servizio_fornitore_versioning_trigger();


-- ======================================
-- TRIGGER - VERSIONING RESPONSABILITA_ENTITY
-- ======================================

-- Rimozione preventiva del trigger se già esistente
DROP TRIGGER IF EXISTS trg_responsabilita_entity_update ON responsabilita_entity;

-- Funzione di versioning per la tabella responsabilita_entity
CREATE OR REPLACE FUNCTION responsabilita_entity_versioning_trigger()
RETURNS TRIGGER AS $$
BEGIN
    
    IF OLD IS NOT DISTINCT FROM NEW THEN
        RETURN NEW;
    END IF;

    
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Chiusura della versione precedente della responsabilità
    UPDATE responsabilita_entity
    SET data_fine_validita = CURRENT_DATE
    WHERE id_resp_entity = OLD.id_resp_entity
      AND data_fine_validita IS NULL;

    -- Inserimento della nuova versione della responsabilità
    INSERT INTO responsabilita_entity (
        id_responsabile,
        tipo_entita,
        id_entita,
        ruolo_responsabile,
        ruolo_responsabilita,
        data_inizio_validita,
        data_fine_validita
    )
    VALUES (
        NEW.id_responsabile,
        NEW.tipo_entita,
        NEW.id_entita,
        NEW.ruolo_responsabile,
        NEW.ruolo_responsabilita,
        CURRENT_DATE,
        NULL
    );
	
	RAISE NOTICE 'Update con chiusura del vecchio dato, andato a buon fine';

    -- Blocco dell'UPDATE originale
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Associazione del trigger alla tabella responsabilita_entity
CREATE TRIGGER trg_responsabilita_entity_update
BEFORE UPDATE ON responsabilita_entity
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE FUNCTION responsabilita_entity_versioning_trigger();
