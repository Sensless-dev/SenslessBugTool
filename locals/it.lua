-- Italian Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['it'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Attività Pendenti',
    ['nav_completed'] = 'Completate',
    ['nav_resources'] = 'Risorse',
    ['nav_lounge'] = 'Lounge Amministratori',
    ['nav_settings'] = 'Impostazioni',
    
    -- Page Titles
    ['page_pending_title'] = 'Attività Pendenti',
    ['page_pending_subtitle'] = 'Gestisci le tue attività attive',
    ['page_completed_title'] = 'Attività Completate',
    ['page_completed_subtitle'] = 'Visualizza il lavoro completato',
    ['page_resources_title'] = 'Risorse',
    ['page_resources_subtitle'] = 'Sfoglia le risorse del server',
    ['page_lounge_title'] = 'Lounge Amministratori',
    ['page_lounge_subtitle'] = 'Chatta con il tuo team',
    ['page_settings_title'] = 'Impostazioni',
    ['page_settings_subtitle'] = 'Personalizza la tua esperienza',
    
    -- Buttons
    ['btn_create_task'] = 'Crea Attività',
    ['btn_close'] = 'Chiudi',
    ['btn_refresh'] = 'Aggiorna',
    ['btn_save'] = 'Salva',
    ['btn_cancel'] = 'Annulla',
    ['btn_confirm'] = 'Conferma',
    ['btn_delete'] = 'Elimina',
    ['btn_complete'] = 'Completa',
    ['btn_reopen'] = 'Riapri',
    ['btn_details'] = 'Dettagli',
    ['btn_send'] = 'Invia',
    ['btn_reset'] = 'Ripristina Predefiniti',
    ['btn_save_settings'] = 'Salva Impostazioni',
    ['btn_copy'] = 'Copia Vector4',
    ['btn_teleport'] = 'Teletrasporta',
    
    -- Task Form
    ['form_title'] = 'Crea Nuova Attività',
    ['form_title_label'] = 'Titolo Attività',
    ['form_title_optional'] = '(Opzionale)',
    ['form_description_label'] = 'Descrizione Attività',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Inserisci la descrizione dell\'attività...',
    ['form_title_placeholder'] = 'Inserisci il titolo dell\'attività...',
    ['form_assigned_label'] = 'Assegnata A',
    ['form_assigned_placeholder'] = 'ID o nome giocatore',
    ['form_priority_label'] = 'Priorità',
    ['form_resource_label'] = 'Risorsa',
    ['form_resource_none'] = 'Nessuna',
    ['form_position_info'] = 'La posizione verrà catturata',
    ['form_position_desc'] = 'La tua posizione attuale (vector4) verrà automaticamente salvata con questa attività',
    
    -- Priorities
    ['priority_low'] = 'Bassa',
    ['priority_normal'] = 'Normale',
    ['priority_high'] = 'Alta',
    ['priority_urgent'] = 'Urgente',
    ['priority_started'] = 'Avviata',
    ['priority_all'] = 'Tutte',
    
    -- Task Status
    ['status_pending'] = 'Pendente',
    ['status_completed'] = 'Completata',
    
    -- Task Details
    ['details_title'] = 'Dettagli Attività',
    ['details_id'] = 'ID Attività',
    ['details_created_by'] = 'Creata Da',
    ['details_created_date'] = 'Creata',
    ['details_assigned_to'] = 'Assegnata A',
    ['details_priority'] = 'Priorità',
    ['details_status'] = 'Stato',
    ['details_resource'] = 'Risorsa',
    ['details_description'] = 'Descrizione',
    ['details_location'] = 'Posizione (Vector4)',
    ['details_coordinates'] = 'Coordinate',
    ['details_completed_by'] = 'Completata Da',
    ['details_completed_date'] = 'Completata',
    ['details_reopen_reason'] = 'Motivo Riapertura',
    
    -- Filters
    ['filter_label'] = 'Filtra per Priorità:',
    
    -- Chat
    ['chat_placeholder'] = 'Digita il tuo messaggio...',
    ['chat_empty'] = 'Nessun messaggio ancora',
    ['chat_empty_desc'] = 'Inizia la conversazione!',
    ['chat_header'] = 'Lounge Chat Amministratori',
    ['chat_subtitle'] = 'Comunica con il tuo team in tempo reale',
    
    -- Resources
    ['resources_empty'] = 'Nessuna risorsa trovata',
    ['resources_loading'] = 'Caricamento risorse...',
    ['resources_files_title'] = 'File della Risorsa',
    ['resources_no_files'] = 'Nessun file trovato',
    
    -- Settings
    ['settings_color_title'] = 'Personalizzazione Colori',
    ['settings_color_desc'] = 'Regola i colori per abbinarli allo stile del tuo server',
    ['settings_ui_title'] = 'Elementi UI',
    ['settings_ui_desc'] = 'Personalizza spaziatura e dimensioni',
    ['settings_bg_title'] = 'Colori Sfondo UI',
    ['settings_bg_desc'] = 'Personalizza i colori di sfondo per diverse aree UI',
    ['settings_text_title'] = 'Colori Testo e Bordo',
    ['settings_text_desc'] = 'Personalizza i colori di testo e bordo',
    ['settings_button_title'] = 'Colori Pulsanti',
    ['settings_button_desc'] = 'Personalizza l\'aspetto dei pulsanti',
    
    -- Setting Labels
    ['setting_accent'] = 'Colore Accento',
    ['setting_accent_desc'] = 'Colore azione principale',
    ['setting_accent_hover'] = 'Accento al Passaggio',
    ['setting_accent_hover_desc'] = 'Colore stato al passaggio',
    ['setting_success'] = 'Colore Successo',
    ['setting_success_desc'] = 'Azioni successo/completamento',
    ['setting_danger'] = 'Colore Pericolo',
    ['setting_danger_desc'] = 'Azioni eliminazione/avviso',
    ['setting_warning'] = 'Colore Avviso',
    ['setting_warning_desc'] = 'Azioni avviso/allerta',
    ['setting_info'] = 'Colore Informazione',
    ['setting_info_desc'] = 'Visualizzazioni informazioni',
    ['setting_bg_primary'] = 'Sfondo Principale',
    ['setting_bg_primary_desc'] = 'Area contenuto principale',
    ['setting_bg_secondary'] = 'Sfondo Secondario',
    ['setting_bg_secondary_desc'] = 'Card e pannelli',
    ['setting_bg_tertiary'] = 'Sfondo Terziario',
    ['setting_bg_tertiary_desc'] = 'Elementi annidati',
    ['setting_sidebar_bg'] = 'Sfondo Barra Laterale',
    ['setting_sidebar_bg_desc'] = 'Barra laterale navigazione',
    ['setting_text_primary'] = 'Testo Principale',
    ['setting_text_primary_desc'] = 'Colore testo principale',
    ['setting_text_secondary'] = 'Testo Secondario',
    ['setting_text_secondary_desc'] = 'Colore testo secondario',
    ['setting_border'] = 'Colore Bordo',
    ['setting_border_desc'] = 'Colore bordo e divisore',
    ['setting_btn_primary'] = 'Pulsante Principale',
    ['setting_btn_primary_desc'] = 'Pulsanti azione principale',
    ['setting_btn_primary_hover'] = 'Pulsante Principale al Passaggio',
    ['setting_btn_primary_hover_desc'] = 'Stato pulsante principale al passaggio',
    ['setting_btn_secondary'] = 'Pulsante Secondario',
    ['setting_btn_secondary_desc'] = 'Pulsanti azione secondaria',
    ['setting_btn_secondary_hover'] = 'Pulsante Secondario al Passaggio',
    ['setting_btn_secondary_hover_desc'] = 'Stato pulsante secondario al passaggio',
    ['setting_border_radius'] = 'Raggio Bordo',
    ['setting_border_radius_desc'] = 'Arrotondamento elementi',
    ['setting_card_shadow'] = 'Ombra Card',
    ['setting_card_shadow_desc'] = 'Intensità ombra',
    
    -- Modals
    ['modal_delete_title'] = 'Elimina Attività',
    ['modal_delete_message'] = 'Sei sicuro di voler eliminare questa attività?',
    ['modal_delete_reason'] = 'Motivo eliminazione',
    ['modal_delete_placeholder'] = 'Inserisci motivo...',
    ['modal_complete_title'] = 'Completa Attività',
    ['modal_complete_message'] = 'Sei sicuro di voler segnare questa attività come completata?',
    ['modal_complete_reason'] = 'Motivo completamento',
    ['modal_complete_placeholder'] = 'Inserisci motivo completamento...',
    ['modal_reopen_title'] = 'Riapri Attività',
    ['modal_reopen_message'] = 'Sei sicuro di voler riaprire questa attività?',
    ['modal_reopen_reason'] = 'Motivo riapertura',
    ['modal_reopen_placeholder'] = 'Inserisci motivo riapertura...',
    ['modal_reset_title'] = 'Ripristina Impostazioni',
    ['modal_reset_message'] = 'Sei sicuro di voler ripristinare tutte le impostazioni ai valori predefiniti? Questa azione non può essere annullata.',
    ['modal_priority_title'] = 'Cambia Priorità',
    
    -- Empty States
    ['empty_no_tasks'] = 'Nessuna attività trovata',
    ['empty_no_pending'] = 'Nessuna attività pendente',
    ['empty_no_completed'] = 'Nessuna attività completata',
    
    -- Notifications
    ['notif_task_created'] = 'Attività creata con successo',
    ['notif_task_deleted'] = 'Attività eliminata con successo',
    ['notif_task_completed'] = 'Attività completata con successo',
    ['notif_task_reopened'] = 'Attività riaperta con successo',
    ['notif_settings_saved'] = 'Impostazioni salvate con successo',
    ['notif_settings_reset'] = 'Impostazioni ripristinate ai valori predefiniti',
    ['notif_teleported'] = 'Teletrasportato alla posizione dell\'attività',
    ['notif_position_copied'] = 'Posizione copiata negli appunti',
    ['notif_error'] = 'Si è verificato un errore',
    ['notif_permission_denied'] = 'Non hai il permesso di utilizzare questo sistema',
    ['notif_invalid_coords'] = 'Coordinate non valide',
    
    -- Validation
    ['validation_description_required'] = 'Inserisci una descrizione dell\'attività',
    ['validation_form_error'] = 'Errore nel modulo. Aggiorna e riprova.',
    
    -- Server Messages
    ['server_permission_denied'] = 'Non hai il permesso di aggiungere attività',
    ['server_task_empty'] = 'La descrizione dell\'attività non può essere vuota',
    ['server_task_failed'] = 'Impossibile creare l\'attività. Riprova.',
}

