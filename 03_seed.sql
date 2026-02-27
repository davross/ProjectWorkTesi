-- ======================================
-- Valorizzazione delle tabelle 
-- ======================================

-- ---------- ASSET ----------
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
VALUES
(
    'Server Web',
    'Server principale per il siti web aziendali',
    'HW',
    'NO',
    2,
    3,
    4,
    'Attivo',
    '2022-03-10',
    NULL
),
(
    'Database CRM',
    'Database per la gestione dei clienti',
    'DB',
    'NO',
    4,
    4,
    4,
    'Attivo',
    '2022-03-10',
    NULL
),
(
    'Applicazione web aziendale',
    'Applicazione web per esporre il sito internet aziendale',
    'SW',
    'SI',
    2,
    3,
    4,
    'Inattivo',
    '2022-03-11',
    '2024-01-31'
),
(
    'Applicazione web 2.0',
    'Nuova applicazione web v2.0 per esporre il sito internet aziendale, completa delle nuove funzionalità e nuova grafica',
    'SW',
    'SI',
    2,
    3,
    4,
    'Attivo',
    '2024-01-31',
    NULL
),
(
    'Applicazione Interna',
    'Applicazione per la gestione delle pratiche interne',
    'SW',
    'NO',
    2,
    3,
    2,
    'Attivo',
    '2023-04-05',
    NULL
),
(
    'Firewall',
    'Firewall di rete principale',
    'HW',
    'NO',
    3,
    4,
    4,
    'Attivo',
    '2022-03-12',
    NULL
),
(
    'Backup Server Web',
    'Server secondario per il siti web, disposto in modalità HA',
    'HW',
    'NO',
    2,
    3,
    4,
    'Attivo',
    '2023-06-15',
    NULL
);

-- ---------- SERVIZIO ----------
INSERT INTO servizio (
    nome,
    descrizione,
    categoria,
    livello_criticita
)
VALUES
(
    'Gestionale Clienti',
    'Servizio per la gestione dei clienti e dei contatti',
    'IT',
    4
),
(
    'E-commerce',
    'Servizio di vendita online',
    'Business',
    4
),
(
    'Backup Database',
    'Servizio di backup dei database critici',
    'IT',
    3
),
(
    'Sito Web Interno',
    'Servizio per il sito web aziendale interno',
    'Business',
    3
);

-- ---------- ASSET_SERVIZIO ----------
INSERT INTO asset_servizio (
    id_asset,
    id_servizio,
    tipo_dipendenza
)
VALUES
(1, 2, 'tecnica'),     
(2, 1, 'tecnica'),     
(5, 1, 'operativa'),   
(6, 2, 'sicurezza'),   
(4, 4, 'tecnica'),     
(7, 4, 'tecnica');     

-- ---------- FORNITORE ----------
INSERT INTO fornitore (
    nome,
    partita_iva,
    tipo,
    contatti,
    data_inizio_validita,
    data_fine_validita
)
VALUES
(
    'WebApp Professional s.r.l.s',
    '1234598760',
    'Fornitore servizi web',
    'WebAppPro@wap.com',
    '2022-03-11',
    '2024-01-31'
),
(
    'CloudProvider S.p.A.',
    '12345678901',
    'Fornitore servizi web',
    'cloud@provider.com',
    '2024-01-31',
    NULL
),
(
    'BlockHack Solutions s.r.l.',
    '98765432109',
    'Fornitore soluzioni di sicurezza',
    'BlockHack@solutions.com',
    '2022-03-10',
    NULL
);

-- ---------- SERVIZIO_FORNITORE ----------
INSERT INTO servizio_fornitore (
    id_servizio,
    id_fornitore,
    ruolo
)
VALUES
(2, 2, 'Hosting infrastruttura web'),
(1, 3, 'Supporto hardware network e sicurezza'),
(4, 2, 'Hosting sito web');

-- ---------- RESPONSABILI ----------
INSERT INTO responsabili (
    owner,
    email,
    ruolo,
    unita_organizzativa
)
VALUES
(
    'Luca Rossi',
    'luca.rossi@example.com',
    'Service Owner',
    'IT'
),
(
    'Maria Bianchi',
    'maria.bianchi@example.com',
    'Asset Owner',
    'IT'
),
(
    'Paolo Verdi',
    'paolo.verdi@example.com',
    'CISO',
    'Sicurezza'
),
(
    'Giulia Neri',
    'giulia.neri@example.com',
    'Asset Owner',
    'IT'
);

-- ---------- RESPONSABILITA_ENTITY ----------
INSERT INTO responsabilita_entity (
    id_responsabile,
    tipo_entita,
    id_entita,
    ruolo_responsabile,
    ruolo_responsabilita
)
VALUES
-- Originari
(
    1,
    'servizio',
    1,
    'Service Owner',
    'Responsabile del servizio Gestionale Clienti'
),
(
    2,
    'asset',
    2,
    'Asset Owner',
    'Responsabile del Database CRM'
),
(
    3,
    'servizio',
    2,
    'Responsabile Sicurezza',
    'Responsabile sicurezza del servizio E-commerce'
),
(
    1,
    'asset',
    5,
    'Gestore operativo',
    'Gestione operativa applicazione interna'
),
(
    2,
    'asset',
    1,
    'Asset Owner',
    'Responsabile Server Web'
),
(
    4,
    'asset',
    4,
    'Asset Owner',
    'Responsabile Applicazione web 2.0'
),
(
    3,
    'asset',
    6,
    'Responsabile Sicurezza',
    'Responsabile Firewall'
),
(
    4,
    'asset',
    7,
    'Asset Owner',
    'Responsabile Backup Server Web'
);
