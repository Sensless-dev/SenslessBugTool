-- Polish Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['pl'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Oczekujące Zadania',
    ['nav_completed'] = 'Zakończone',
    ['nav_resources'] = 'Zasoby',
    ['nav_lounge'] = 'Lounge Administratora',
    ['nav_settings'] = 'Ustawienia',
    
    -- Page Titles
    ['page_pending_title'] = 'Oczekujące Zadania',
    ['page_pending_subtitle'] = 'Zarządzaj aktywnymi zadaniami',
    ['page_completed_title'] = 'Zakończone Zadania',
    ['page_completed_subtitle'] = 'Zobacz zakończoną pracę',
    ['page_resources_title'] = 'Zasoby',
    ['page_resources_subtitle'] = 'Przeglądaj zasoby serwera',
    ['page_lounge_title'] = 'Lounge Administratora',
    ['page_lounge_subtitle'] = 'Czatuj z zespołem',
    ['page_settings_title'] = 'Ustawienia',
    ['page_settings_subtitle'] = 'Dostosuj swoje doświadczenie',
    
    -- Buttons
    ['btn_create_task'] = 'Utwórz Zadanie',
    ['btn_close'] = 'Zamknij',
    ['btn_refresh'] = 'Odśwież',
    ['btn_save'] = 'Zapisz',
    ['btn_cancel'] = 'Anuluj',
    ['btn_confirm'] = 'Potwierdź',
    ['btn_delete'] = 'Usuń',
    ['btn_complete'] = 'Zakończ',
    ['btn_reopen'] = 'Ponownie Otwórz',
    ['btn_details'] = 'Szczegóły',
    ['btn_send'] = 'Wyślij',
    ['btn_reset'] = 'Przywróć Domyślne',
    ['btn_save_settings'] = 'Zapisz Ustawienia',
    ['btn_copy'] = 'Kopiuj Vector4',
    ['btn_teleport'] = 'Teleportuj',
    
    -- Task Form
    ['form_title'] = 'Utwórz Nowe Zadanie',
    ['form_title_label'] = 'Tytuł Zadania',
    ['form_title_optional'] = '(Opcjonalne)',
    ['form_description_label'] = 'Opis Zadania',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Wprowadź opis zadania...',
    ['form_title_placeholder'] = 'Wprowadź tytuł zadania...',
    ['form_assigned_label'] = 'Przypisane Do',
    ['form_assigned_placeholder'] = 'ID lub nazwa gracza',
    ['form_priority_label'] = 'Priorytet',
    ['form_resource_label'] = 'Zasób',
    ['form_resource_none'] = 'Brak',
    ['form_position_info'] = 'Pozycja zostanie przechwycona',
    ['form_position_desc'] = 'Twoja aktualna lokalizacja (vector4) zostanie automatycznie zapisana z tym zadaniem',
    
    -- Priorities
    ['priority_low'] = 'Niski',
    ['priority_normal'] = 'Normalny',
    ['priority_high'] = 'Wysoki',
    ['priority_urgent'] = 'Pilny',
    ['priority_started'] = 'Rozpoczęty',
    ['priority_all'] = 'Wszystkie',
    
    -- Task Status
    ['status_pending'] = 'Oczekujące',
    ['status_completed'] = 'Zakończone',
    
    -- Task Details
    ['details_title'] = 'Szczegóły Zadania',
    ['details_id'] = 'ID Zadania',
    ['details_created_by'] = 'Utworzone Przez',
    ['details_created_date'] = 'Utworzone',
    ['details_assigned_to'] = 'Przypisane Do',
    ['details_priority'] = 'Priorytet',
    ['details_status'] = 'Status',
    ['details_resource'] = 'Zasób',
    ['details_description'] = 'Opis',
    ['details_location'] = 'Lokalizacja (Vector4)',
    ['details_coordinates'] = 'Współrzędne',
    ['details_completed_by'] = 'Zakończone Przez',
    ['details_completed_date'] = 'Zakończone',
    ['details_reopen_reason'] = 'Powód Ponownego Otwarcia',
    
    -- Filters
    ['filter_label'] = 'Filtruj według Priorytetu:',
    
    -- Chat
    ['chat_placeholder'] = 'Wpisz swoją wiadomość...',
    ['chat_empty'] = 'Brak wiadomości',
    ['chat_empty_desc'] = 'Rozpocznij rozmowę!',
    ['chat_header'] = 'Lounge Czatu Administratora',
    ['chat_subtitle'] = 'Komunikuj się z zespołem w czasie rzeczywistym',
    
    -- Resources
    ['resources_empty'] = 'Nie znaleziono zasobów',
    ['resources_loading'] = 'Ładowanie zasobów...',
    ['resources_files_title'] = 'Pliki Zasobu',
    ['resources_no_files'] = 'Nie znaleziono plików',
    
    -- Settings
    ['settings_color_title'] = 'Dostosowanie Kolorów',
    ['settings_color_desc'] = 'Dostosuj kolory, aby pasowały do stylu serwera',
    ['settings_ui_title'] = 'Elementy Interfejsu',
    ['settings_ui_desc'] = 'Dostosuj odstępy i rozmiary',
    ['settings_bg_title'] = 'Kolory Tła Interfejsu',
    ['settings_bg_desc'] = 'Dostosuj kolory tła dla różnych obszarów interfejsu',
    ['settings_text_title'] = 'Kolory Tekstu i Obramowania',
    ['settings_text_desc'] = 'Dostosuj kolory tekstu i obramowania',
    ['settings_button_title'] = 'Kolory Przycisków',
    ['settings_button_desc'] = 'Dostosuj wygląd przycisków',
    
    -- Setting Labels
    ['setting_accent'] = 'Kolor Akcentu',
    ['setting_accent_desc'] = 'Główny kolor akcji',
    ['setting_accent_hover'] = 'Akcent przy Najechaniu',
    ['setting_accent_hover_desc'] = 'Kolor stanu przy najechaniu',
    ['setting_success'] = 'Kolor Sukcesu',
    ['setting_success_desc'] = 'Akcje sukcesu/zakończenia',
    ['setting_danger'] = 'Kolor Niebezpieczeństwa',
    ['setting_danger_desc'] = 'Akcje usuwania/ostrzeżenia',
    ['setting_warning'] = 'Kolor Ostrzeżenia',
    ['setting_warning_desc'] = 'Akcje ostrzeżenia/alertu',
    ['setting_info'] = 'Kolor Informacji',
    ['setting_info_desc'] = 'Wyświetlacze informacji',
    ['setting_bg_primary'] = 'Główne Tło',
    ['setting_bg_primary_desc'] = 'Główny obszar treści',
    ['setting_bg_secondary'] = 'Drugorzędne Tło',
    ['setting_bg_secondary_desc'] = 'Karty i panele',
    ['setting_bg_tertiary'] = 'Trzeciorzędne Tło',
    ['setting_bg_tertiary_desc'] = 'Zagnieżdżone elementy',
    ['setting_sidebar_bg'] = 'Tło Paska Bocznego',
    ['setting_sidebar_bg_desc'] = 'Boczny pasek nawigacji',
    ['setting_text_primary'] = 'Główny Tekst',
    ['setting_text_primary_desc'] = 'Główny kolor tekstu',
    ['setting_text_secondary'] = 'Drugorzędny Tekst',
    ['setting_text_secondary_desc'] = 'Drugorzędny kolor tekstu',
    ['setting_border'] = 'Kolor Obramowania',
    ['setting_border_desc'] = 'Kolor obramowania i separatora',
    ['setting_btn_primary'] = 'Główny Przycisk',
    ['setting_btn_primary_desc'] = 'Główne przyciski akcji',
    ['setting_btn_primary_hover'] = 'Główny Przycisk przy Najechaniu',
    ['setting_btn_primary_hover_desc'] = 'Stan głównego przycisku przy najechaniu',
    ['setting_btn_secondary'] = 'Drugorzędny Przycisk',
    ['setting_btn_secondary_desc'] = 'Drugorzędne przyciski akcji',
    ['setting_btn_secondary_hover'] = 'Drugorzędny Przycisk przy Najechaniu',
    ['setting_btn_secondary_hover_desc'] = 'Stan drugorzędnego przycisku przy najechaniu',
    ['setting_border_radius'] = 'Promień Obramowania',
    ['setting_border_radius_desc'] = 'Zaokrąglenie elementów',
    ['setting_card_shadow'] = 'Cień Karty',
    ['setting_card_shadow_desc'] = 'Intensywność cienia',
    
    -- Modals
    ['modal_delete_title'] = 'Usuń Zadanie',
    ['modal_delete_message'] = 'Czy na pewno chcesz usunąć to zadanie?',
    ['modal_delete_reason'] = 'Powód usunięcia',
    ['modal_delete_placeholder'] = 'Wprowadź powód...',
    ['modal_complete_title'] = 'Zakończ Zadanie',
    ['modal_complete_message'] = 'Czy na pewno chcesz oznaczyć to zadanie jako zakończone?',
    ['modal_complete_reason'] = 'Powód zakończenia',
    ['modal_complete_placeholder'] = 'Wprowadź powód zakończenia...',
    ['modal_reopen_title'] = 'Ponownie Otwórz Zadanie',
    ['modal_reopen_message'] = 'Czy na pewno chcesz ponownie otworzyć to zadanie?',
    ['modal_reopen_reason'] = 'Powód ponownego otwarcia',
    ['modal_reopen_placeholder'] = 'Wprowadź powód ponownego otwarcia...',
    ['modal_reset_title'] = 'Przywróć Ustawienia',
    ['modal_reset_message'] = 'Czy na pewno chcesz przywrócić wszystkie ustawienia do wartości domyślnych? Tej operacji nie można cofnąć.',
    ['modal_priority_title'] = 'Zmień Priorytet',
    
    -- Empty States
    ['empty_no_tasks'] = 'Nie znaleziono zadań',
    ['empty_no_pending'] = 'Brak oczekujących zadań',
    ['empty_no_completed'] = 'Brak zakończonych zadań',
    
    -- Notifications
    ['notif_task_created'] = 'Zadanie utworzone pomyślnie',
    ['notif_task_deleted'] = 'Zadanie usunięte pomyślnie',
    ['notif_task_completed'] = 'Zadanie zakończone pomyślnie',
    ['notif_task_reopened'] = 'Zadanie ponownie otwarte pomyślnie',
    ['notif_settings_saved'] = 'Ustawienia zapisane pomyślnie',
    ['notif_settings_reset'] = 'Ustawienia przywrócone do wartości domyślnych',
    ['notif_teleported'] = 'Teleportowano do lokalizacji zadania',
    ['notif_position_copied'] = 'Pozycja skopiowana do schowka',
    ['notif_error'] = 'Wystąpił błąd',
    ['notif_permission_denied'] = 'Nie masz uprawnień do korzystania z tego systemu',
    ['notif_invalid_coords'] = 'Nieprawidłowe współrzędne',
    
    -- Validation
    ['validation_description_required'] = 'Proszę wprowadzić opis zadania',
    ['validation_form_error'] = 'Błąd formularza. Proszę odświeżyć i spróbować ponownie.',
    
    -- Server Messages
    ['server_permission_denied'] = 'Nie masz uprawnień do dodawania zadań',
    ['server_task_empty'] = 'Opis zadania nie może być pusty',
    ['server_task_failed'] = 'Nie udało się utworzyć zadania. Proszę spróbować ponownie.',
}

