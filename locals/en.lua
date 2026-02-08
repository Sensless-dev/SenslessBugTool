-- English Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['en'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'Made By senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Pending Tasks',
    ['nav_completed'] = 'Completed',
    ['nav_resources'] = 'Resources',
    ['nav_lounge'] = 'Admin Lounge',
    ['nav_settings'] = 'Settings',
    
    -- Page Titles
    ['page_pending_title'] = 'Pending Tasks',
    ['page_pending_subtitle'] = 'Manage your active tasks',
    ['page_completed_title'] = 'Completed Tasks',
    ['page_completed_subtitle'] = 'View completed work',
    ['page_resources_title'] = 'Resources',
    ['page_resources_subtitle'] = 'Browse server resources',
    ['page_lounge_title'] = 'Admin Lounge',
    ['page_lounge_subtitle'] = 'Chat with your team',
    ['page_settings_title'] = 'Settings',
    ['page_settings_subtitle'] = 'Customize your experience',
    
    -- Buttons
    ['btn_create_task'] = 'Create Task',
    ['btn_close'] = 'Close',
    ['btn_refresh'] = 'Refresh',
    ['btn_save'] = 'Save',
    ['btn_cancel'] = 'Cancel',
    ['btn_confirm'] = 'Confirm',
    ['btn_delete'] = 'Delete',
    ['btn_complete'] = 'Complete',
    ['btn_reopen'] = 'Reopen',
    ['btn_details'] = 'Details',
    ['btn_send'] = 'Send',
    ['btn_reset'] = 'Reset to Default',
    ['btn_save_settings'] = 'Save Settings',
    ['btn_copy'] = 'Copy Vector4',
    ['btn_teleport'] = 'Teleport',
    
    -- Task Form
    ['form_title'] = 'Create New Task',
    ['form_title_label'] = 'Task Title',
    ['form_title_optional'] = '(Optional)',
    ['form_description_label'] = 'Task Description',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Enter task description...',
    ['form_title_placeholder'] = 'Enter task title...',
    ['form_assigned_label'] = 'Assigned To',
    ['form_assigned_placeholder'] = 'Player ID or name',
    ['form_priority_label'] = 'Priority',
    ['form_resource_label'] = 'Resource',
    ['form_resource_none'] = 'None',
    ['form_position_info'] = 'Position will be captured',
    ['form_position_desc'] = 'Your current location (vector4) will be automatically saved with this task',
    
    -- Priorities
    ['priority_low'] = 'Low',
    ['priority_normal'] = 'Normal',
    ['priority_high'] = 'High',
    ['priority_urgent'] = 'Urgent',
    ['priority_started'] = 'Started',
    ['priority_all'] = 'All',
    
    -- Task Status
    ['status_pending'] = 'Pending',
    ['status_completed'] = 'Completed',
    
    -- Task Details
    ['details_title'] = 'Task Details',
    ['details_id'] = 'Task ID',
    ['details_created_by'] = 'Created By',
    ['details_created_date'] = 'Created',
    ['details_assigned_to'] = 'Assigned To',
    ['details_priority'] = 'Priority',
    ['details_status'] = 'Status',
    ['details_resource'] = 'Resource',
    ['details_description'] = 'Description',
    ['details_location'] = 'Location (Vector4)',
    ['details_coordinates'] = 'Coordinates',
    ['details_completed_by'] = 'Completed By',
    ['details_completed_date'] = 'Completed',
    ['details_reopen_reason'] = 'Reopen Reason',
    
    -- Filters
    ['filter_label'] = 'Filter by Priority:',
    
    -- Chat
    ['chat_placeholder'] = 'Type your message...',
    ['chat_empty'] = 'No messages yet',
    ['chat_empty_desc'] = 'Start the conversation!',
    ['chat_header'] = 'Admin Chat Lounge',
    ['chat_subtitle'] = 'Communicate with your team in real-time',
    
    -- Resources
    ['resources_empty'] = 'No resources found',
    ['resources_loading'] = 'Loading resources...',
    ['resources_files_title'] = 'Resource Files',
    ['resources_no_files'] = 'No files found',
    
    -- Settings
    ['settings_color_title'] = 'Color Customization',
    ['settings_color_desc'] = 'Adjust colors to match your server\'s style',
    ['settings_ui_title'] = 'UI Elements',
    ['settings_ui_desc'] = 'Customize spacing and sizes',
    ['settings_bg_title'] = 'UI Background Colors',
    ['settings_bg_desc'] = 'Customize background colors for different UI areas',
    ['settings_text_title'] = 'Text & Border Colors',
    ['settings_text_desc'] = 'Customize text and border colors',
    ['settings_button_title'] = 'Button Colors',
    ['settings_button_desc'] = 'Customize button appearance',
    
    -- Setting Labels
    ['setting_accent'] = 'Accent Color',
    ['setting_accent_desc'] = 'Primary action color',
    ['setting_accent_hover'] = 'Accent Hover',
    ['setting_accent_hover_desc'] = 'Hover state color',
    ['setting_success'] = 'Success Color',
    ['setting_success_desc'] = 'Success/complete actions',
    ['setting_danger'] = 'Danger Color',
    ['setting_danger_desc'] = 'Delete/warning actions',
    ['setting_warning'] = 'Warning Color',
    ['setting_warning_desc'] = 'Warning/alert actions',
    ['setting_info'] = 'Info Color',
    ['setting_info_desc'] = 'Information displays',
    ['setting_bg_primary'] = 'Primary Background',
    ['setting_bg_primary_desc'] = 'Main content area',
    ['setting_bg_secondary'] = 'Secondary Background',
    ['setting_bg_secondary_desc'] = 'Cards and panels',
    ['setting_bg_tertiary'] = 'Tertiary Background',
    ['setting_bg_tertiary_desc'] = 'Nested elements',
    ['setting_sidebar_bg'] = 'Sidebar Background',
    ['setting_sidebar_bg_desc'] = 'Navigation sidebar',
    ['setting_text_primary'] = 'Primary Text',
    ['setting_text_primary_desc'] = 'Main text color',
    ['setting_text_secondary'] = 'Secondary Text',
    ['setting_text_secondary_desc'] = 'Secondary text color',
    ['setting_border'] = 'Border Color',
    ['setting_border_desc'] = 'Border and divider color',
    ['setting_btn_primary'] = 'Primary Button',
    ['setting_btn_primary_desc'] = 'Main action buttons',
    ['setting_btn_primary_hover'] = 'Primary Button Hover',
    ['setting_btn_primary_hover_desc'] = 'Primary button hover state',
    ['setting_btn_secondary'] = 'Secondary Button',
    ['setting_btn_secondary_desc'] = 'Secondary action buttons',
    ['setting_btn_secondary_hover'] = 'Secondary Button Hover',
    ['setting_btn_secondary_hover_desc'] = 'Secondary button hover state',
    ['setting_border_radius'] = 'Border Radius',
    ['setting_border_radius_desc'] = 'Roundness of elements',
    ['setting_card_shadow'] = 'Card Shadow',
    ['setting_card_shadow_desc'] = 'Shadow intensity',
    
    -- Modals
    ['modal_delete_title'] = 'Delete Task',
    ['modal_delete_message'] = 'Are you sure you want to delete this task?',
    ['modal_delete_reason'] = 'Reason for deletion',
    ['modal_delete_placeholder'] = 'Enter reason...',
    ['modal_complete_title'] = 'Complete Task',
    ['modal_complete_message'] = 'Are you sure you want to mark this task as completed?',
    ['modal_complete_reason'] = 'Completion reason',
    ['modal_complete_placeholder'] = 'Enter completion reason...',
    ['modal_reopen_title'] = 'Reopen Task',
    ['modal_reopen_message'] = 'Are you sure you want to reopen this task?',
    ['modal_reopen_reason'] = 'Reopen reason',
    ['modal_reopen_placeholder'] = 'Enter reopen reason...',
    ['modal_reset_title'] = 'Reset Settings',
    ['modal_reset_message'] = 'Are you sure you want to reset all settings to default values? This cannot be undone.',
    ['modal_priority_title'] = 'Change Priority',
    
    -- Empty States
    ['empty_no_tasks'] = 'No tasks found',
    ['empty_no_pending'] = 'No pending tasks',
    ['empty_no_completed'] = 'No completed tasks',
    
    -- Notifications
    ['notif_task_created'] = 'Task created successfully',
    ['notif_task_deleted'] = 'Task deleted successfully',
    ['notif_task_completed'] = 'Task completed successfully',
    ['notif_task_reopened'] = 'Task reopened successfully',
    ['notif_settings_saved'] = 'Settings saved successfully',
    ['notif_settings_reset'] = 'Settings reset to default values',
    ['notif_teleported'] = 'Teleported to task location',
    ['notif_position_copied'] = 'Position copied to clipboard',
    ['notif_error'] = 'An error occurred',
    ['notif_permission_denied'] = 'You do not have permission to use this system',
    ['notif_invalid_coords'] = 'Invalid coordinates',
    
    -- Validation
    ['validation_description_required'] = 'Please enter a task description',
    ['validation_form_error'] = 'Form error. Please refresh and try again.',
    
    -- Server Messages
    ['server_permission_denied'] = 'You do not have permission to add tasks',
    ['server_task_empty'] = 'Task description cannot be empty',
    ['server_task_failed'] = 'Failed to create task. Please try again.',
}

