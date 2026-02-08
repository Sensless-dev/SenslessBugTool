-- German Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['de'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Ausstehende Aufgaben',
    ['nav_completed'] = 'Abgeschlossen',
    ['nav_resources'] = 'Ressourcen',
    ['nav_lounge'] = 'Admin-Lounge',
    ['nav_settings'] = 'Einstellungen',
    
    -- Page Titles
    ['page_pending_title'] = 'Ausstehende Aufgaben',
    ['page_pending_subtitle'] = 'Verwalten Sie Ihre aktiven Aufgaben',
    ['page_completed_title'] = 'Abgeschlossene Aufgaben',
    ['page_completed_subtitle'] = 'Abgeschlossene Arbeit anzeigen',
    ['page_resources_title'] = 'Ressourcen',
    ['page_resources_subtitle'] = 'Server-Ressourcen durchsuchen',
    ['page_lounge_title'] = 'Admin-Lounge',
    ['page_lounge_subtitle'] = 'Chatten Sie mit Ihrem Team',
    ['page_settings_title'] = 'Einstellungen',
    ['page_settings_subtitle'] = 'Passen Sie Ihre Erfahrung an',
    
    -- Buttons
    ['btn_create_task'] = 'Aufgabe Erstellen',
    ['btn_close'] = 'Schließen',
    ['btn_refresh'] = 'Aktualisieren',
    ['btn_save'] = 'Speichern',
    ['btn_cancel'] = 'Abbrechen',
    ['btn_confirm'] = 'Bestätigen',
    ['btn_delete'] = 'Löschen',
    ['btn_complete'] = 'Abschließen',
    ['btn_reopen'] = 'Wiedereröffnen',
    ['btn_details'] = 'Details',
    ['btn_send'] = 'Senden',
    ['btn_reset'] = 'Auf Standard Zurücksetzen',
    ['btn_save_settings'] = 'Einstellungen Speichern',
    ['btn_copy'] = 'Vector4 Kopieren',
    ['btn_teleport'] = 'Teleportieren',
    
    -- Task Form
    ['form_title'] = 'Neue Aufgabe Erstellen',
    ['form_title_label'] = 'Aufgabentitel',
    ['form_title_optional'] = '(Optional)',
    ['form_description_label'] = 'Aufgabenbeschreibung',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Aufgabenbeschreibung eingeben...',
    ['form_title_placeholder'] = 'Aufgabentitel eingeben...',
    ['form_assigned_label'] = 'Zugewiesen An',
    ['form_assigned_placeholder'] = 'Spieler-ID oder Name',
    ['form_priority_label'] = 'Priorität',
    ['form_resource_label'] = 'Ressource',
    ['form_resource_none'] = 'Keine',
    ['form_position_info'] = 'Position wird erfasst',
    ['form_position_desc'] = 'Ihr aktueller Standort (vector4) wird automatisch mit dieser Aufgabe gespeichert',
    
    -- Priorities
    ['priority_low'] = 'Niedrig',
    ['priority_normal'] = 'Normal',
    ['priority_high'] = 'Hoch',
    ['priority_urgent'] = 'Dringend',
    ['priority_started'] = 'Gestartet',
    ['priority_all'] = 'Alle',
    
    -- Task Status
    ['status_pending'] = 'Ausstehend',
    ['status_completed'] = 'Abgeschlossen',
    
    -- Task Details
    ['details_title'] = 'Aufgabendetails',
    ['details_id'] = 'Aufgaben-ID',
    ['details_created_by'] = 'Erstellt Von',
    ['details_created_date'] = 'Erstellt',
    ['details_assigned_to'] = 'Zugewiesen An',
    ['details_priority'] = 'Priorität',
    ['details_status'] = 'Status',
    ['details_resource'] = 'Ressource',
    ['details_description'] = 'Beschreibung',
    ['details_location'] = 'Standort (Vector4)',
    ['details_coordinates'] = 'Koordinaten',
    ['details_completed_by'] = 'Abgeschlossen Von',
    ['details_completed_date'] = 'Abgeschlossen',
    ['details_reopen_reason'] = 'Grund für Wiedereröffnung',
    
    -- Filters
    ['filter_label'] = 'Nach Priorität filtern:',
    
    -- Chat
    ['chat_placeholder'] = 'Geben Sie Ihre Nachricht ein...',
    ['chat_empty'] = 'Noch keine Nachrichten',
    ['chat_empty_desc'] = 'Starten Sie die Unterhaltung!',
    ['chat_header'] = 'Admin-Chat-Lounge',
    ['chat_subtitle'] = 'Kommunizieren Sie in Echtzeit mit Ihrem Team',
    
    -- Resources
    ['resources_empty'] = 'Keine Ressourcen gefunden',
    ['resources_loading'] = 'Ressourcen werden geladen...',
    ['resources_files_title'] = 'Ressourcendateien',
    ['resources_no_files'] = 'Keine Dateien gefunden',
    
    -- Settings
    ['settings_color_title'] = 'Farbanpassung',
    ['settings_color_desc'] = 'Passen Sie die Farben an den Stil Ihres Servers an',
    ['settings_ui_title'] = 'UI-Elemente',
    ['settings_ui_desc'] = 'Abstände und Größen anpassen',
    ['settings_bg_title'] = 'UI-Hintergrundfarben',
    ['settings_bg_desc'] = 'Hintergrundfarben für verschiedene UI-Bereiche anpassen',
    ['settings_text_title'] = 'Text- und Rahmenfarben',
    ['settings_text_desc'] = 'Text- und Rahmenfarben anpassen',
    ['settings_button_title'] = 'Schaltflächenfarben',
    ['settings_button_desc'] = 'Erscheinungsbild der Schaltflächen anpassen',
    
    -- Setting Labels
    ['setting_accent'] = 'Akzentfarbe',
    ['setting_accent_desc'] = 'Hauptaktionsfarbe',
    ['setting_accent_hover'] = 'Akzent beim Überfahren',
    ['setting_accent_hover_desc'] = 'Farbe des Hover-Zustands',
    ['setting_success'] = 'Erfolgsfarbe',
    ['setting_success_desc'] = 'Erfolgs-/Abschlussaktionen',
    ['setting_danger'] = 'Gefahrenfarbe',
    ['setting_danger_desc'] = 'Lösch-/Warnaktionen',
    ['setting_warning'] = 'Warnfarbe',
    ['setting_warning_desc'] = 'Warn-/Alarmaktionen',
    ['setting_info'] = 'Informationsfarbe',
    ['setting_info_desc'] = 'Informationsanzeigen',
    ['setting_bg_primary'] = 'Primärer Hintergrund',
    ['setting_bg_primary_desc'] = 'Hauptinhaltbereich',
    ['setting_bg_secondary'] = 'Sekundärer Hintergrund',
    ['setting_bg_secondary_desc'] = 'Karten und Panels',
    ['setting_bg_tertiary'] = 'Tertiärer Hintergrund',
    ['setting_bg_tertiary_desc'] = 'Verschachtelte Elemente',
    ['setting_sidebar_bg'] = 'Seitenleisten-Hintergrund',
    ['setting_sidebar_bg_desc'] = 'Navigationsseitenleiste',
    ['setting_text_primary'] = 'Primärer Text',
    ['setting_text_primary_desc'] = 'Haupttextfarbe',
    ['setting_text_secondary'] = 'Sekundärer Text',
    ['setting_text_secondary_desc'] = 'Sekundäre Textfarbe',
    ['setting_border'] = 'Rahmenfarbe',
    ['setting_border_desc'] = 'Rahmen- und Trennlinienfarbe',
    ['setting_btn_primary'] = 'Primäre Schaltfläche',
    ['setting_btn_primary_desc'] = 'Hauptaktionsschaltflächen',
    ['setting_btn_primary_hover'] = 'Primäre Schaltfläche beim Überfahren',
    ['setting_btn_primary_hover_desc'] = 'Hover-Zustand der primären Schaltfläche',
    ['setting_btn_secondary'] = 'Sekundäre Schaltfläche',
    ['setting_btn_secondary_desc'] = 'Sekundäre Aktionsschaltflächen',
    ['setting_btn_secondary_hover'] = 'Sekundäre Schaltfläche beim Überfahren',
    ['setting_btn_secondary_hover_desc'] = 'Hover-Zustand der sekundären Schaltfläche',
    ['setting_border_radius'] = 'Rahmenradius',
    ['setting_border_radius_desc'] = 'Rundheit der Elemente',
    ['setting_card_shadow'] = 'Kartenschatten',
    ['setting_card_shadow_desc'] = 'Schattenintensität',
    
    -- Modals
    ['modal_delete_title'] = 'Aufgabe Löschen',
    ['modal_delete_message'] = 'Sind Sie sicher, dass Sie diese Aufgabe löschen möchten?',
    ['modal_delete_reason'] = 'Grund für die Löschung',
    ['modal_delete_placeholder'] = 'Grund eingeben...',
    ['modal_complete_title'] = 'Aufgabe Abschließen',
    ['modal_complete_message'] = 'Sind Sie sicher, dass Sie diese Aufgabe als abgeschlossen markieren möchten?',
    ['modal_complete_reason'] = 'Grund für den Abschluss',
    ['modal_complete_placeholder'] = 'Grund für den Abschluss eingeben...',
    ['modal_reopen_title'] = 'Aufgabe Wiedereröffnen',
    ['modal_reopen_message'] = 'Sind Sie sicher, dass Sie diese Aufgabe wiedereröffnen möchten?',
    ['modal_reopen_reason'] = 'Grund für die Wiedereröffnung',
    ['modal_reopen_placeholder'] = 'Grund für die Wiedereröffnung eingeben...',
    ['modal_reset_title'] = 'Einstellungen Zurücksetzen',
    ['modal_reset_message'] = 'Sind Sie sicher, dass Sie alle Einstellungen auf die Standardwerte zurücksetzen möchten? Dies kann nicht rückgängig gemacht werden.',
    ['modal_priority_title'] = 'Priorität Ändern',
    
    -- Empty States
    ['empty_no_tasks'] = 'Keine Aufgaben gefunden',
    ['empty_no_pending'] = 'Keine ausstehenden Aufgaben',
    ['empty_no_completed'] = 'Keine abgeschlossenen Aufgaben',
    
    -- Notifications
    ['notif_task_created'] = 'Aufgabe erfolgreich erstellt',
    ['notif_task_deleted'] = 'Aufgabe erfolgreich gelöscht',
    ['notif_task_completed'] = 'Aufgabe erfolgreich abgeschlossen',
    ['notif_task_reopened'] = 'Aufgabe erfolgreich wiedereröffnet',
    ['notif_settings_saved'] = 'Einstellungen erfolgreich gespeichert',
    ['notif_settings_reset'] = 'Einstellungen auf Standardwerte zurückgesetzt',
    ['notif_teleported'] = 'Zur Aufgabenposition teleportiert',
    ['notif_position_copied'] = 'Position in die Zwischenablage kopiert',
    ['notif_error'] = 'Ein Fehler ist aufgetreten',
    ['notif_permission_denied'] = 'Sie haben keine Berechtigung, dieses System zu verwenden',
    ['notif_invalid_coords'] = 'Ungültige Koordinaten',
    
    -- Validation
    ['validation_description_required'] = 'Bitte geben Sie eine Aufgabenbeschreibung ein',
    ['validation_form_error'] = 'Formularfehler. Bitte aktualisieren und erneut versuchen.',
    
    -- Server Messages
    ['server_permission_denied'] = 'Sie haben keine Berechtigung, Aufgaben hinzuzufügen',
    ['server_task_empty'] = 'Die Aufgabenbeschreibung darf nicht leer sein',
    ['server_task_failed'] = 'Fehler beim Erstellen der Aufgabe. Bitte versuchen Sie es erneut.',
}

