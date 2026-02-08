-- Spanish Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['es'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Tareas Pendientes',
    ['nav_completed'] = 'Completadas',
    ['nav_resources'] = 'Recursos',
    ['nav_lounge'] = 'Sala de Administradores',
    ['nav_settings'] = 'Configuración',
    
    -- Page Titles
    ['page_pending_title'] = 'Tareas Pendientes',
    ['page_pending_subtitle'] = 'Gestiona tus tareas activas',
    ['page_completed_title'] = 'Tareas Completadas',
    ['page_completed_subtitle'] = 'Ver trabajo completado',
    ['page_resources_title'] = 'Recursos',
    ['page_resources_subtitle'] = 'Explorar recursos del servidor',
    ['page_lounge_title'] = 'Sala de Administradores',
    ['page_lounge_subtitle'] = 'Chatea con tu equipo',
    ['page_settings_title'] = 'Configuración',
    ['page_settings_subtitle'] = 'Personaliza tu experiencia',
    
    -- Buttons
    ['btn_create_task'] = 'Crear Tarea',
    ['btn_close'] = 'Cerrar',
    ['btn_refresh'] = 'Actualizar',
    ['btn_save'] = 'Guardar',
    ['btn_cancel'] = 'Cancelar',
    ['btn_confirm'] = 'Confirmar',
    ['btn_delete'] = 'Eliminar',
    ['btn_complete'] = 'Completar',
    ['btn_reopen'] = 'Reabrir',
    ['btn_details'] = 'Detalles',
    ['btn_send'] = 'Enviar',
    ['btn_reset'] = 'Restablecer por Defecto',
    ['btn_save_settings'] = 'Guardar Configuración',
    ['btn_copy'] = 'Copiar Vector4',
    ['btn_teleport'] = 'Teletransportar',
    
    -- Task Form
    ['form_title'] = 'Crear Nueva Tarea',
    ['form_title_label'] = 'Título de la Tarea',
    ['form_title_optional'] = '(Opcional)',
    ['form_description_label'] = 'Descripción de la Tarea',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Ingresa la descripción de la tarea...',
    ['form_title_placeholder'] = 'Ingresa el título de la tarea...',
    ['form_assigned_label'] = 'Asignado A',
    ['form_assigned_placeholder'] = 'ID o nombre del jugador',
    ['form_priority_label'] = 'Prioridad',
    ['form_resource_label'] = 'Recurso',
    ['form_resource_none'] = 'Ninguno',
    ['form_position_info'] = 'Se capturará la posición',
    ['form_position_desc'] = 'Tu ubicación actual (vector4) se guardará automáticamente con esta tarea',
    
    -- Priorities
    ['priority_low'] = 'Baja',
    ['priority_normal'] = 'Normal',
    ['priority_high'] = 'Alta',
    ['priority_urgent'] = 'Urgente',
    ['priority_started'] = 'Iniciada',
    ['priority_all'] = 'Todas',
    
    -- Task Status
    ['status_pending'] = 'Pendiente',
    ['status_completed'] = 'Completada',
    
    -- Task Details
    ['details_title'] = 'Detalles de la Tarea',
    ['details_id'] = 'ID de Tarea',
    ['details_created_by'] = 'Creado Por',
    ['details_created_date'] = 'Creado',
    ['details_assigned_to'] = 'Asignado A',
    ['details_priority'] = 'Prioridad',
    ['details_status'] = 'Estado',
    ['details_resource'] = 'Recurso',
    ['details_description'] = 'Descripción',
    ['details_location'] = 'Ubicación (Vector4)',
    ['details_coordinates'] = 'Coordenadas',
    ['details_completed_by'] = 'Completado Por',
    ['details_completed_date'] = 'Completado',
    ['details_reopen_reason'] = 'Razón de Reapertura',
    
    -- Filters
    ['filter_label'] = 'Filtrar por Prioridad:',
    
    -- Chat
    ['chat_placeholder'] = 'Escribe tu mensaje...',
    ['chat_empty'] = 'Aún no hay mensajes',
    ['chat_empty_desc'] = '¡Inicia la conversación!',
    ['chat_header'] = 'Sala de Chat de Administradores',
    ['chat_subtitle'] = 'Comunícate con tu equipo en tiempo real',
    
    -- Resources
    ['resources_empty'] = 'No se encontraron recursos',
    ['resources_loading'] = 'Cargando recursos...',
    ['resources_files_title'] = 'Archivos del Recurso',
    ['resources_no_files'] = 'No se encontraron archivos',
    
    -- Settings
    ['settings_color_title'] = 'Personalización de Colores',
    ['settings_color_desc'] = 'Ajusta los colores para que coincidan con el estilo de tu servidor',
    ['settings_ui_title'] = 'Elementos de la UI',
    ['settings_ui_desc'] = 'Personaliza espaciado y tamaños',
    ['settings_bg_title'] = 'Colores de Fondo de la UI',
    ['settings_bg_desc'] = 'Personaliza los colores de fondo para diferentes áreas de la UI',
    ['settings_text_title'] = 'Colores de Texto y Borde',
    ['settings_text_desc'] = 'Personaliza los colores de texto y borde',
    ['settings_button_title'] = 'Colores de Botones',
    ['settings_button_desc'] = 'Personaliza la apariencia de los botones',
    
    -- Setting Labels
    ['setting_accent'] = 'Color de Acento',
    ['setting_accent_desc'] = 'Color de acción principal',
    ['setting_accent_hover'] = 'Acento al Pasar el Mouse',
    ['setting_accent_hover_desc'] = 'Color del estado al pasar el mouse',
    ['setting_success'] = 'Color de Éxito',
    ['setting_success_desc'] = 'Acciones de éxito/completado',
    ['setting_danger'] = 'Color de Peligro',
    ['setting_danger_desc'] = 'Acciones de eliminar/advertencia',
    ['setting_warning'] = 'Color de Advertencia',
    ['setting_warning_desc'] = 'Acciones de advertencia/alerta',
    ['setting_info'] = 'Color de Información',
    ['setting_info_desc'] = 'Pantallas de información',
    ['setting_bg_primary'] = 'Fondo Principal',
    ['setting_bg_primary_desc'] = 'Área de contenido principal',
    ['setting_bg_secondary'] = 'Fondo Secundario',
    ['setting_bg_secondary_desc'] = 'Tarjetas y paneles',
    ['setting_bg_tertiary'] = 'Fondo Terciario',
    ['setting_bg_tertiary_desc'] = 'Elementos anidados',
    ['setting_sidebar_bg'] = 'Fondo de la Barra Lateral',
    ['setting_sidebar_bg_desc'] = 'Barra lateral de navegación',
    ['setting_text_primary'] = 'Texto Principal',
    ['setting_text_primary_desc'] = 'Color del texto principal',
    ['setting_text_secondary'] = 'Texto Secundario',
    ['setting_text_secondary_desc'] = 'Color del texto secundario',
    ['setting_border'] = 'Color del Borde',
    ['setting_border_desc'] = 'Color de borde y divisor',
    ['setting_btn_primary'] = 'Botón Principal',
    ['setting_btn_primary_desc'] = 'Botones de acción principal',
    ['setting_btn_primary_hover'] = 'Botón Principal al Pasar el Mouse',
    ['setting_btn_primary_hover_desc'] = 'Estado del botón principal al pasar el mouse',
    ['setting_btn_secondary'] = 'Botón Secundario',
    ['setting_btn_secondary_desc'] = 'Botones de acción secundaria',
    ['setting_btn_secondary_hover'] = 'Botón Secundario al Pasar el Mouse',
    ['setting_btn_secondary_hover_desc'] = 'Estado del botón secundario al pasar el mouse',
    ['setting_border_radius'] = 'Radio del Borde',
    ['setting_border_radius_desc'] = 'Redondez de los elementos',
    ['setting_card_shadow'] = 'Sombra de la Tarjeta',
    ['setting_card_shadow_desc'] = 'Intensidad de la sombra',
    
    -- Modals
    ['modal_delete_title'] = 'Eliminar Tarea',
    ['modal_delete_message'] = '¿Estás seguro de que deseas eliminar esta tarea?',
    ['modal_delete_reason'] = 'Razón de eliminación',
    ['modal_delete_placeholder'] = 'Ingresa la razón...',
    ['modal_complete_title'] = 'Completar Tarea',
    ['modal_complete_message'] = '¿Estás seguro de que deseas marcar esta tarea como completada?',
    ['modal_complete_reason'] = 'Razón de finalización',
    ['modal_complete_placeholder'] = 'Ingresa la razón de finalización...',
    ['modal_reopen_title'] = 'Reabrir Tarea',
    ['modal_reopen_message'] = '¿Estás seguro de que deseas reabrir esta tarea?',
    ['modal_reopen_reason'] = 'Razón de reapertura',
    ['modal_reopen_placeholder'] = 'Ingresa la razón de reapertura...',
    ['modal_reset_title'] = 'Restablecer Configuración',
    ['modal_reset_message'] = '¿Estás seguro de que deseas restablecer toda la configuración a los valores predeterminados? Esto no se puede deshacer.',
    ['modal_priority_title'] = 'Cambiar Prioridad',
    
    -- Empty States
    ['empty_no_tasks'] = 'No se encontraron tareas',
    ['empty_no_pending'] = 'No hay tareas pendientes',
    ['empty_no_completed'] = 'No hay tareas completadas',
    
    -- Notifications
    ['notif_task_created'] = 'Tarea creada exitosamente',
    ['notif_task_deleted'] = 'Tarea eliminada exitosamente',
    ['notif_task_completed'] = 'Tarea completada exitosamente',
    ['notif_task_reopened'] = 'Tarea reabierta exitosamente',
    ['notif_settings_saved'] = 'Configuración guardada exitosamente',
    ['notif_settings_reset'] = 'Configuración restablecida a los valores predeterminados',
    ['notif_teleported'] = 'Teletransportado a la ubicación de la tarea',
    ['notif_position_copied'] = 'Posición copiada al portapapeles',
    ['notif_error'] = 'Ocurrió un error',
    ['notif_permission_denied'] = 'No tienes permiso para usar este sistema',
    ['notif_invalid_coords'] = 'Coordenadas inválidas',
    
    -- Validation
    ['validation_description_required'] = 'Por favor ingresa una descripción de la tarea',
    ['validation_form_error'] = 'Error en el formulario. Por favor actualiza e intenta de nuevo.',
    
    -- Server Messages
    ['server_permission_denied'] = 'No tienes permiso para agregar tareas',
    ['server_task_empty'] = 'La descripción de la tarea no puede estar vacía',
    ['server_task_failed'] = 'Error al crear la tarea. Por favor intenta de nuevo.',
}

