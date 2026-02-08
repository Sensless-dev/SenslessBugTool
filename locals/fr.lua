-- French Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['fr'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Tâches en Attente',
    ['nav_completed'] = 'Terminées',
    ['nav_resources'] = 'Ressources',
    ['nav_lounge'] = 'Salon Administrateur',
    ['nav_settings'] = 'Paramètres',
    
    -- Page Titles
    ['page_pending_title'] = 'Tâches en Attente',
    ['page_pending_subtitle'] = 'Gérez vos tâches actives',
    ['page_completed_title'] = 'Tâches Terminées',
    ['page_completed_subtitle'] = 'Voir le travail terminé',
    ['page_resources_title'] = 'Ressources',
    ['page_resources_subtitle'] = 'Parcourir les ressources du serveur',
    ['page_lounge_title'] = 'Salon Administrateur',
    ['page_lounge_subtitle'] = 'Discutez avec votre équipe',
    ['page_settings_title'] = 'Paramètres',
    ['page_settings_subtitle'] = 'Personnalisez votre expérience',
    
    -- Buttons
    ['btn_create_task'] = 'Créer une Tâche',
    ['btn_close'] = 'Fermer',
    ['btn_refresh'] = 'Actualiser',
    ['btn_save'] = 'Enregistrer',
    ['btn_cancel'] = 'Annuler',
    ['btn_confirm'] = 'Confirmer',
    ['btn_delete'] = 'Supprimer',
    ['btn_complete'] = 'Terminer',
    ['btn_reopen'] = 'Rouvrir',
    ['btn_details'] = 'Détails',
    ['btn_send'] = 'Envoyer',
    ['btn_reset'] = 'Réinitialiser par Défaut',
    ['btn_save_settings'] = 'Enregistrer les Paramètres',
    ['btn_copy'] = 'Copier Vector4',
    ['btn_teleport'] = 'Téléporter',
    
    -- Task Form
    ['form_title'] = 'Créer une Nouvelle Tâche',
    ['form_title_label'] = 'Titre de la Tâche',
    ['form_title_optional'] = '(Optionnel)',
    ['form_description_label'] = 'Description de la Tâche',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Entrez la description de la tâche...',
    ['form_title_placeholder'] = 'Entrez le titre de la tâche...',
    ['form_assigned_label'] = 'Assigné À',
    ['form_assigned_placeholder'] = 'ID ou nom du joueur',
    ['form_priority_label'] = 'Priorité',
    ['form_resource_label'] = 'Ressource',
    ['form_resource_none'] = 'Aucune',
    ['form_position_info'] = 'La position sera capturée',
    ['form_position_desc'] = 'Votre emplacement actuel (vector4) sera automatiquement enregistré avec cette tâche',
    
    -- Priorities
    ['priority_low'] = 'Basse',
    ['priority_normal'] = 'Normale',
    ['priority_high'] = 'Haute',
    ['priority_urgent'] = 'Urgente',
    ['priority_started'] = 'Démarrée',
    ['priority_all'] = 'Toutes',
    
    -- Task Status
    ['status_pending'] = 'En Attente',
    ['status_completed'] = 'Terminée',
    
    -- Task Details
    ['details_title'] = 'Détails de la Tâche',
    ['details_id'] = 'ID de la Tâche',
    ['details_created_by'] = 'Créé Par',
    ['details_created_date'] = 'Créé',
    ['details_assigned_to'] = 'Assigné À',
    ['details_priority'] = 'Priorité',
    ['details_status'] = 'Statut',
    ['details_resource'] = 'Ressource',
    ['details_description'] = 'Description',
    ['details_location'] = 'Emplacement (Vector4)',
    ['details_coordinates'] = 'Coordonnées',
    ['details_completed_by'] = 'Terminé Par',
    ['details_completed_date'] = 'Terminé',
    ['details_reopen_reason'] = 'Raison de Réouverture',
    
    -- Filters
    ['filter_label'] = 'Filtrer par Priorité:',
    
    -- Chat
    ['chat_placeholder'] = 'Tapez votre message...',
    ['chat_empty'] = 'Aucun message pour le moment',
    ['chat_empty_desc'] = 'Commencez la conversation!',
    ['chat_header'] = 'Salon de Chat Administrateur',
    ['chat_subtitle'] = 'Communiquez avec votre équipe en temps réel',
    
    -- Resources
    ['resources_empty'] = 'Aucune ressource trouvée',
    ['resources_loading'] = 'Chargement des ressources...',
    ['resources_files_title'] = 'Fichiers de la Ressource',
    ['resources_no_files'] = 'Aucun fichier trouvé',
    
    -- Settings
    ['settings_color_title'] = 'Personnalisation des Couleurs',
    ['settings_color_desc'] = 'Ajustez les couleurs pour correspondre au style de votre serveur',
    ['settings_ui_title'] = 'Éléments de l\'Interface',
    ['settings_ui_desc'] = 'Personnalisez l\'espacement et les tailles',
    ['settings_bg_title'] = 'Couleurs de Fond de l\'Interface',
    ['settings_bg_desc'] = 'Personnalisez les couleurs de fond pour différentes zones de l\'interface',
    ['settings_text_title'] = 'Couleurs du Texte et des Bordures',
    ['settings_text_desc'] = 'Personnalisez les couleurs du texte et des bordures',
    ['settings_button_title'] = 'Couleurs des Boutons',
    ['settings_button_desc'] = 'Personnalisez l\'apparence des boutons',
    
    -- Setting Labels
    ['setting_accent'] = 'Couleur d\'Accent',
    ['setting_accent_desc'] = 'Couleur d\'action principale',
    ['setting_accent_hover'] = 'Accent au Survol',
    ['setting_accent_hover_desc'] = 'Couleur de l\'état au survol',
    ['setting_success'] = 'Couleur de Succès',
    ['setting_success_desc'] = 'Actions de succès/terminé',
    ['setting_danger'] = 'Couleur de Danger',
    ['setting_danger_desc'] = 'Actions de suppression/avertissement',
    ['setting_warning'] = 'Couleur d\'Avertissement',
    ['setting_warning_desc'] = 'Actions d\'avertissement/alerte',
    ['setting_info'] = 'Couleur d\'Information',
    ['setting_info_desc'] = 'Affichages d\'information',
    ['setting_bg_primary'] = 'Fond Principal',
    ['setting_bg_primary_desc'] = 'Zone de contenu principal',
    ['setting_bg_secondary'] = 'Fond Secondaire',
    ['setting_bg_secondary_desc'] = 'Cartes et panneaux',
    ['setting_bg_tertiary'] = 'Fond Tertiaire',
    ['setting_bg_tertiary_desc'] = 'Éléments imbriqués',
    ['setting_sidebar_bg'] = 'Fond de la Barre Latérale',
    ['setting_sidebar_bg_desc'] = 'Barre latérale de navigation',
    ['setting_text_primary'] = 'Texte Principal',
    ['setting_text_primary_desc'] = 'Couleur du texte principal',
    ['setting_text_secondary'] = 'Texte Secondaire',
    ['setting_text_secondary_desc'] = 'Couleur du texte secondaire',
    ['setting_border'] = 'Couleur de la Bordure',
    ['setting_border_desc'] = 'Couleur de la bordure et du séparateur',
    ['setting_btn_primary'] = 'Bouton Principal',
    ['setting_btn_primary_desc'] = 'Boutons d\'action principale',
    ['setting_btn_primary_hover'] = 'Bouton Principal au Survol',
    ['setting_btn_primary_hover_desc'] = 'État du bouton principal au survol',
    ['setting_btn_secondary'] = 'Bouton Secondaire',
    ['setting_btn_secondary_desc'] = 'Boutons d\'action secondaire',
    ['setting_btn_secondary_hover'] = 'Bouton Secondaire au Survol',
    ['setting_btn_secondary_hover_desc'] = 'État du bouton secondaire au survol',
    ['setting_border_radius'] = 'Rayon de la Bordure',
    ['setting_border_radius_desc'] = 'Arrondi des éléments',
    ['setting_card_shadow'] = 'Ombre de la Carte',
    ['setting_card_shadow_desc'] = 'Intensité de l\'ombre',
    
    -- Modals
    ['modal_delete_title'] = 'Supprimer la Tâche',
    ['modal_delete_message'] = 'Êtes-vous sûr de vouloir supprimer cette tâche?',
    ['modal_delete_reason'] = 'Raison de suppression',
    ['modal_delete_placeholder'] = 'Entrez la raison...',
    ['modal_complete_title'] = 'Terminer la Tâche',
    ['modal_complete_message'] = 'Êtes-vous sûr de vouloir marquer cette tâche comme terminée?',
    ['modal_complete_reason'] = 'Raison de finalisation',
    ['modal_complete_placeholder'] = 'Entrez la raison de finalisation...',
    ['modal_reopen_title'] = 'Rouvrir la Tâche',
    ['modal_reopen_message'] = 'Êtes-vous sûr de vouloir rouvrir cette tâche?',
    ['modal_reopen_reason'] = 'Raison de réouverture',
    ['modal_reopen_placeholder'] = 'Entrez la raison de réouverture...',
    ['modal_reset_title'] = 'Réinitialiser les Paramètres',
    ['modal_reset_message'] = 'Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut? Cette action est irréversible.',
    ['modal_priority_title'] = 'Changer la Priorité',
    
    -- Empty States
    ['empty_no_tasks'] = 'Aucune tâche trouvée',
    ['empty_no_pending'] = 'Aucune tâche en attente',
    ['empty_no_completed'] = 'Aucune tâche terminée',
    
    -- Notifications
    ['notif_task_created'] = 'Tâche créée avec succès',
    ['notif_task_deleted'] = 'Tâche supprimée avec succès',
    ['notif_task_completed'] = 'Tâche terminée avec succès',
    ['notif_task_reopened'] = 'Tâche rouverte avec succès',
    ['notif_settings_saved'] = 'Paramètres enregistrés avec succès',
    ['notif_settings_reset'] = 'Paramètres réinitialisés aux valeurs par défaut',
    ['notif_teleported'] = 'Téléporté à l\'emplacement de la tâche',
    ['notif_position_copied'] = 'Position copiée dans le presse-papiers',
    ['notif_error'] = 'Une erreur s\'est produite',
    ['notif_permission_denied'] = 'Vous n\'avez pas la permission d\'utiliser ce système',
    ['notif_invalid_coords'] = 'Coordonnées invalides',
    
    -- Validation
    ['validation_description_required'] = 'Veuillez entrer une description de la tâche',
    ['validation_form_error'] = 'Erreur de formulaire. Veuillez actualiser et réessayer.',
    
    -- Server Messages
    ['server_permission_denied'] = 'Vous n\'avez pas la permission d\'ajouter des tâches',
    ['server_task_empty'] = 'La description de la tâche ne peut pas être vide',
    ['server_task_failed'] = 'Échec de la création de la tâche. Veuillez réessayer.',
}

