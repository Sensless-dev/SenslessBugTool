-- Dutch Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['nl'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Openstaande Taken',
    ['nav_completed'] = 'Voltooid',
    ['nav_resources'] = 'Resources',
    ['nav_lounge'] = 'Admin Lounge',
    ['nav_settings'] = 'Instellingen',
    
    -- Page Titles
    ['page_pending_title'] = 'Openstaande Taken',
    ['page_pending_subtitle'] = 'Beheer uw actieve taken',
    ['page_completed_title'] = 'Voltooide Taken',
    ['page_completed_subtitle'] = 'Bekijk voltooide werk',
    ['page_resources_title'] = 'Resources',
    ['page_resources_subtitle'] = 'Blader door server resources',
    ['page_lounge_title'] = 'Admin Lounge',
    ['page_lounge_subtitle'] = 'Chat met uw team',
    ['page_settings_title'] = 'Instellingen',
    ['page_settings_subtitle'] = 'Pas uw ervaring aan',
    
    -- Buttons
    ['btn_create_task'] = 'Taak Maken',
    ['btn_close'] = 'Sluiten',
    ['btn_refresh'] = 'Vernieuwen',
    ['btn_save'] = 'Opslaan',
    ['btn_cancel'] = 'Annuleren',
    ['btn_confirm'] = 'Bevestigen',
    ['btn_delete'] = 'Verwijderen',
    ['btn_complete'] = 'Voltooien',
    ['btn_reopen'] = 'Heropenen',
    ['btn_details'] = 'Details',
    ['btn_send'] = 'Verzenden',
    ['btn_reset'] = 'Reset naar Standaard',
    ['btn_save_settings'] = 'Instellingen Opslaan',
    ['btn_copy'] = 'Vector4 Kopiëren',
    ['btn_teleport'] = 'Teleporteren',
    
    -- Task Form
    ['form_title'] = 'Nieuwe Taak Maken',
    ['form_title_label'] = 'Taaktitel',
    ['form_title_optional'] = '(Optioneel)',
    ['form_description_label'] = 'Taakbeschrijving',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Voer taakbeschrijving in...',
    ['form_title_placeholder'] = 'Voer taaktitel in...',
    ['form_assigned_label'] = 'Toegewezen Aan',
    ['form_assigned_placeholder'] = 'Speler-ID of naam',
    ['form_priority_label'] = 'Prioriteit',
    ['form_resource_label'] = 'Resource',
    ['form_resource_none'] = 'Geen',
    ['form_position_info'] = 'Positie wordt vastgelegd',
    ['form_position_desc'] = 'Uw huidige locatie (vector4) wordt automatisch opgeslagen met deze taak',
    
    -- Priorities
    ['priority_low'] = 'Laag',
    ['priority_normal'] = 'Normaal',
    ['priority_high'] = 'Hoog',
    ['priority_urgent'] = 'Urgent',
    ['priority_started'] = 'Gestart',
    ['priority_all'] = 'Alle',
    
    -- Task Status
    ['status_pending'] = 'Openstaand',
    ['status_completed'] = 'Voltooid',
    
    -- Task Details
    ['details_title'] = 'Taakdetails',
    ['details_id'] = 'Taak-ID',
    ['details_created_by'] = 'Gemaakt Door',
    ['details_created_date'] = 'Gemaakt',
    ['details_assigned_to'] = 'Toegewezen Aan',
    ['details_priority'] = 'Prioriteit',
    ['details_status'] = 'Status',
    ['details_resource'] = 'Resource',
    ['details_description'] = 'Beschrijving',
    ['details_location'] = 'Locatie (Vector4)',
    ['details_coordinates'] = 'Coördinaten',
    ['details_completed_by'] = 'Voltooid Door',
    ['details_completed_date'] = 'Voltooid',
    ['details_reopen_reason'] = 'Reden voor Heropening',
    
    -- Filters
    ['filter_label'] = 'Filteren op Prioriteit:',
    
    -- Chat
    ['chat_placeholder'] = 'Typ uw bericht...',
    ['chat_empty'] = 'Nog geen berichten',
    ['chat_empty_desc'] = 'Start het gesprek!',
    ['chat_header'] = 'Admin Chat Lounge',
    ['chat_subtitle'] = 'Communiceer in realtime met uw team',
    
    -- Resources
    ['resources_empty'] = 'Geen resources gevonden',
    ['resources_loading'] = 'Resources laden...',
    ['resources_files_title'] = 'Resource Bestanden',
    ['resources_no_files'] = 'Geen bestanden gevonden',
    
    -- Settings
    ['settings_color_title'] = 'Kleuraanpassing',
    ['settings_color_desc'] = 'Pas kleuren aan om overeen te komen met de stijl van uw server',
    ['settings_ui_title'] = 'UI Elementen',
    ['settings_ui_desc'] = 'Pas afstand en groottes aan',
    ['settings_bg_title'] = 'UI Achtergrondkleuren',
    ['settings_bg_desc'] = 'Pas achtergrondkleuren aan voor verschillende UI-gebieden',
    ['settings_text_title'] = 'Tekst- en Randkleuren',
    ['settings_text_desc'] = 'Pas tekst- en randkleuren aan',
    ['settings_button_title'] = 'Knopkleuren',
    ['settings_button_desc'] = 'Pas het uiterlijk van knoppen aan',
    
    -- Setting Labels
    ['setting_accent'] = 'Accentkleur',
    ['setting_accent_desc'] = 'Primaire actiekleur',
    ['setting_accent_hover'] = 'Accent bij Hover',
    ['setting_accent_hover_desc'] = 'Hover statuskleur',
    ['setting_success'] = 'Succeskleur',
    ['setting_success_desc'] = 'Succes/voltooi acties',
    ['setting_danger'] = 'Gevaarkleur',
    ['setting_danger_desc'] = 'Verwijder/waarschuwing acties',
    ['setting_warning'] = 'Waarschuwingskleur',
    ['setting_warning_desc'] = 'Waarschuwing/alert acties',
    ['setting_info'] = 'Informatiekleur',
    ['setting_info_desc'] = 'Informatieweergaven',
    ['setting_bg_primary'] = 'Primaire Achtergrond',
    ['setting_bg_primary_desc'] = 'Hoofdinhoudsgebied',
    ['setting_bg_secondary'] = 'Secundaire Achtergrond',
    ['setting_bg_secondary_desc'] = 'Kaarten en panelen',
    ['setting_bg_tertiary'] = 'Tertiaire Achtergrond',
    ['setting_bg_tertiary_desc'] = 'Geneste elementen',
    ['setting_sidebar_bg'] = 'Zijbalk Achtergrond',
    ['setting_sidebar_bg_desc'] = 'Navigatie zijbalk',
    ['setting_text_primary'] = 'Primaire Tekst',
    ['setting_text_primary_desc'] = 'Hoofdtekstkleur',
    ['setting_text_secondary'] = 'Secundaire Tekst',
    ['setting_text_secondary_desc'] = 'Secundaire tekstkleur',
    ['setting_border'] = 'Randkleur',
    ['setting_border_desc'] = 'Rand- en scheidingslijnkleur',
    ['setting_btn_primary'] = 'Primaire Knop',
    ['setting_btn_primary_desc'] = 'Primaire actieknoppen',
    ['setting_btn_primary_hover'] = 'Primaire Knop bij Hover',
    ['setting_btn_primary_hover_desc'] = 'Primaire knop hover status',
    ['setting_btn_secondary'] = 'Secundaire Knop',
    ['setting_btn_secondary_desc'] = 'Secundaire actieknoppen',
    ['setting_btn_secondary_hover'] = 'Secundaire Knop bij Hover',
    ['setting_btn_secondary_hover_desc'] = 'Secundaire knop hover status',
    ['setting_border_radius'] = 'Randradius',
    ['setting_border_radius_desc'] = 'Rondheid van elementen',
    ['setting_card_shadow'] = 'Kaart Schaduw',
    ['setting_card_shadow_desc'] = 'Schaduwintensiteit',
    
    -- Modals
    ['modal_delete_title'] = 'Taak Verwijderen',
    ['modal_delete_message'] = 'Weet u zeker dat u deze taak wilt verwijderen?',
    ['modal_delete_reason'] = 'Reden voor verwijdering',
    ['modal_delete_placeholder'] = 'Voer reden in...',
    ['modal_complete_title'] = 'Taak Voltooien',
    ['modal_complete_message'] = 'Weet u zeker dat u deze taak als voltooid wilt markeren?',
    ['modal_complete_reason'] = 'Voltooiingsreden',
    ['modal_complete_placeholder'] = 'Voer voltooiingsreden in...',
    ['modal_reopen_title'] = 'Taak Heropenen',
    ['modal_reopen_message'] = 'Weet u zeker dat u deze taak wilt heropenen?',
    ['modal_reopen_reason'] = 'Heropeningsreden',
    ['modal_reopen_placeholder'] = 'Voer heropeningsreden in...',
    ['modal_reset_title'] = 'Instellingen Resetten',
    ['modal_reset_message'] = 'Weet u zeker dat u alle instellingen wilt resetten naar de standaardwaarden? Dit kan niet ongedaan worden gemaakt.',
    ['modal_priority_title'] = 'Prioriteit Wijzigen',
    
    -- Empty States
    ['empty_no_tasks'] = 'Geen taken gevonden',
    ['empty_no_pending'] = 'Geen openstaande taken',
    ['empty_no_completed'] = 'Geen voltooide taken',
    
    -- Notifications
    ['notif_task_created'] = 'Taak succesvol aangemaakt',
    ['notif_task_deleted'] = 'Taak succesvol verwijderd',
    ['notif_task_completed'] = 'Taak succesvol voltooid',
    ['notif_task_reopened'] = 'Taak succesvol heropend',
    ['notif_settings_saved'] = 'Instellingen succesvol opgeslagen',
    ['notif_settings_reset'] = 'Instellingen gereset naar standaardwaarden',
    ['notif_teleported'] = 'Geteleporteerd naar taaklocatie',
    ['notif_position_copied'] = 'Positie gekopieerd naar klembord',
    ['notif_error'] = 'Er is een fout opgetreden',
    ['notif_permission_denied'] = 'U heeft geen toestemming om dit systeem te gebruiken',
    ['notif_invalid_coords'] = 'Ongeldige coördinaten',
    
    -- Validation
    ['validation_description_required'] = 'Voer alstublieft een taakbeschrijving in',
    ['validation_form_error'] = 'Formulierfout. Vernieuw alstublieft en probeer opnieuw.',
    
    -- Server Messages
    ['server_permission_denied'] = 'U heeft geen toestemming om taken toe te voegen',
    ['server_task_empty'] = 'Taakbeschrijving mag niet leeg zijn',
    ['server_task_failed'] = 'Mislukt om taak aan te maken. Probeer het alstublieft opnieuw.',
}

