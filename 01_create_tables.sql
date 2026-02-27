-- ======================================
-- TABELLE PRINCIPALI
-- ======================================

-- Tabella Asset Aziendali
CREATE TABLE asset (
    id_asset SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    categoria VARCHAR(50),
	esposizione_internet VARCHAR(5),

    -- Valutazione impatto (CIA)
    impatto_confidenzialita SMALLINT NOT NULL CHECK (impatto_confidenzialita BETWEEN 1 AND 4),
    impatto_integrita SMALLINT NOT NULL CHECK (impatto_integrita BETWEEN 1 AND 4),
    impatto_disponibilita SMALLINT NOT NULL CHECK (impatto_disponibilita BETWEEN 1 AND 4),

    valore_criticita_intrinseca SMALLINT GENERATED ALWAYS AS (
    (impatto_confidenzialita +
     impatto_integrita +
     impatto_disponibilita) / 3
) STORED,

    stato VARCHAR(50) NOT NULL,
    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);


-- Tabella Servizio 
CREATE TABLE servizio (
    id_servizio SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    categoria VARCHAR(50),

    livello_criticita SMALLINT NOT NULL CHECK (livello_criticita BETWEEN 1 AND 4),

    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);


-- Tabella Fornitore 
CREATE TABLE fornitore (
    id_fornitore SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    partita_iva VARCHAR(20),
    tipo VARCHAR(50),
    contatti TEXT,
    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);

-- Tabella Responsabili
CREATE TABLE responsabili (
    id_responsabile SERIAL PRIMARY KEY,
    owner VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    ruolo VARCHAR(50),
    unita_organizzativa VARCHAR(50)
);


--Tabelle di relazione


-- Relazione Asset ↔ Servizio
CREATE TABLE asset_servizio (
    id_asset_servizio SERIAL PRIMARY KEY,
    id_asset INT NOT NULL REFERENCES asset(id_asset) ON DELETE CASCADE,
    id_servizio INT NOT NULL REFERENCES servizio(id_servizio) ON DELETE CASCADE,
    tipo_dipendenza VARCHAR(50),
    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);

-- Relazione Servizio ↔ Fornitore
CREATE TABLE servizio_fornitore (
    id_servizio_fornitore SERIAL PRIMARY KEY,
    id_servizio INT NOT NULL REFERENCES servizio(id_servizio) ON DELETE CASCADE,
    id_fornitore INT NOT NULL REFERENCES fornitore(id_fornitore) ON DELETE CASCADE,
    ruolo VARCHAR(50),
    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);


-- Tabella responsabilità generica

-- Relazione Responsabile ↔ Asset o Servizio
CREATE TABLE responsabilita_entity (
    id_resp_entity SERIAL PRIMARY KEY,
    id_responsabile INT NOT NULL REFERENCES responsabili(id_responsabile) ON DELETE CASCADE,
    tipo_entita VARCHAR(20) NOT NULL CHECK (tipo_entita IN ('asset','servizio')),
    id_entita INT NOT NULL,

    -- Ruolo standardizzato per semplificare l'export 
    ruolo_responsabile VARCHAR(30) NOT NULL CHECK (
        ruolo_responsabile IN (
            'Asset Owner',
            'Service Owner',
            'Responsabile Sicurezza',
            'Gestore operativo',
            'Altro'
        )
    ),

    -- Descrizione del ruolo
    ruolo_responsabilita VARCHAR(100),

    data_inizio_validita DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fine_validita DATE
);


-- Indici

-- Indici per velocizzare ricerche
CREATE INDEX idx_asset_nome ON asset(nome);
CREATE INDEX idx_servizio_nome ON servizio(nome);
CREATE INDEX idx_fornitore_nome ON fornitore(nome);
CREATE INDEX idx_responsabile_owner ON responsabili(owner);

-- Indici sulle relazioni
CREATE INDEX idx_asset_servizio_fk ON asset_servizio(id_asset, id_servizio);
CREATE INDEX idx_servizio_fornitore_fk ON servizio_fornitore(id_servizio, id_fornitore);
CREATE INDEX idx_resp_entity_fk ON responsabilita_entity(id_responsabile, id_entita);

-- Indice per l'export del profilo responsabile
CREATE INDEX idx_resp_entity_ruolo_acn
ON responsabilita_entity (ruolo_responsabile);