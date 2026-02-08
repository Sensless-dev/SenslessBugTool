-- Portuguese Language File
-- LDN DEV-LINK Admin To-Do System

Locales = Locales or {}
Locales['pt'] = {
    -- UI Titles
    ['app_title'] = 'BUG TOOL',
    ['app_subtitle'] = 'MADE BY senslessDev',
    
    -- Navigation
    ['nav_pending'] = 'Tarefas Pendentes',
    ['nav_completed'] = 'Concluídas',
    ['nav_resources'] = 'Recursos',
    ['nav_lounge'] = 'Sala de Administradores',
    ['nav_settings'] = 'Configurações',
    
    -- Page Titles
    ['page_pending_title'] = 'Tarefas Pendentes',
    ['page_pending_subtitle'] = 'Gerencie suas tarefas ativas',
    ['page_completed_title'] = 'Tarefas Concluídas',
    ['page_completed_subtitle'] = 'Ver trabalho concluído',
    ['page_resources_title'] = 'Recursos',
    ['page_resources_subtitle'] = 'Navegar pelos recursos do servidor',
    ['page_lounge_title'] = 'Sala de Administradores',
    ['page_lounge_subtitle'] = 'Converse com sua equipe',
    ['page_settings_title'] = 'Configurações',
    ['page_settings_subtitle'] = 'Personalize sua experiência',
    
    -- Buttons
    ['btn_create_task'] = 'Criar Tarefa',
    ['btn_close'] = 'Fechar',
    ['btn_refresh'] = 'Atualizar',
    ['btn_save'] = 'Salvar',
    ['btn_cancel'] = 'Cancelar',
    ['btn_confirm'] = 'Confirmar',
    ['btn_delete'] = 'Excluir',
    ['btn_complete'] = 'Concluir',
    ['btn_reopen'] = 'Reabrir',
    ['btn_details'] = 'Detalhes',
    ['btn_send'] = 'Enviar',
    ['btn_reset'] = 'Redefinir para Padrão',
    ['btn_save_settings'] = 'Salvar Configurações',
    ['btn_copy'] = 'Copiar Vector4',
    ['btn_teleport'] = 'Teleportar',
    
    -- Task Form
    ['form_title'] = 'Criar Nova Tarefa',
    ['form_title_label'] = 'Título da Tarefa',
    ['form_title_optional'] = '(Opcional)',
    ['form_description_label'] = 'Descrição da Tarefa',
    ['form_description_required'] = '*',
    ['form_description_placeholder'] = 'Digite a descrição da tarefa...',
    ['form_title_placeholder'] = 'Digite o título da tarefa...',
    ['form_assigned_label'] = 'Atribuído A',
    ['form_assigned_placeholder'] = 'ID ou nome do jogador',
    ['form_priority_label'] = 'Prioridade',
    ['form_resource_label'] = 'Recurso',
    ['form_resource_none'] = 'Nenhum',
    ['form_position_info'] = 'Posição será capturada',
    ['form_position_desc'] = 'Sua localização atual (vector4) será automaticamente salva com esta tarefa',
    
    -- Priorities
    ['priority_low'] = 'Baixa',
    ['priority_normal'] = 'Normal',
    ['priority_high'] = 'Alta',
    ['priority_urgent'] = 'Urgente',
    ['priority_started'] = 'Iniciada',
    ['priority_all'] = 'Todas',
    
    -- Task Status
    ['status_pending'] = 'Pendente',
    ['status_completed'] = 'Concluída',
    
    -- Task Details
    ['details_title'] = 'Detalhes da Tarefa',
    ['details_id'] = 'ID da Tarefa',
    ['details_created_by'] = 'Criado Por',
    ['details_created_date'] = 'Criado',
    ['details_assigned_to'] = 'Atribuído A',
    ['details_priority'] = 'Prioridade',
    ['details_status'] = 'Status',
    ['details_resource'] = 'Recurso',
    ['details_description'] = 'Descrição',
    ['details_location'] = 'Localização (Vector4)',
    ['details_coordinates'] = 'Coordenadas',
    ['details_completed_by'] = 'Concluído Por',
    ['details_completed_date'] = 'Concluído',
    ['details_reopen_reason'] = 'Motivo da Reabertura',
    
    -- Filters
    ['filter_label'] = 'Filtrar por Prioridade:',
    
    -- Chat
    ['chat_placeholder'] = 'Digite sua mensagem...',
    ['chat_empty'] = 'Ainda não há mensagens',
    ['chat_empty_desc'] = 'Inicie a conversa!',
    ['chat_header'] = 'Sala de Chat de Administradores',
    ['chat_subtitle'] = 'Comunique-se com sua equipe em tempo real',
    
    -- Resources
    ['resources_empty'] = 'Nenhum recurso encontrado',
    ['resources_loading'] = 'Carregando recursos...',
    ['resources_files_title'] = 'Arquivos do Recurso',
    ['resources_no_files'] = 'Nenhum arquivo encontrado',
    
    -- Settings
    ['settings_color_title'] = 'Personalização de Cores',
    ['settings_color_desc'] = 'Ajuste as cores para corresponder ao estilo do seu servidor',
    ['settings_ui_title'] = 'Elementos da Interface',
    ['settings_ui_desc'] = 'Personalize espaçamento e tamanhos',
    ['settings_bg_title'] = 'Cores de Fundo da Interface',
    ['settings_bg_desc'] = 'Personalize as cores de fundo para diferentes áreas da interface',
    ['settings_text_title'] = 'Cores de Texto e Borda',
    ['settings_text_desc'] = 'Personalize as cores de texto e borda',
    ['settings_button_title'] = 'Cores dos Botões',
    ['settings_button_desc'] = 'Personalize a aparência dos botões',
    
    -- Setting Labels
    ['setting_accent'] = 'Cor de Destaque',
    ['setting_accent_desc'] = 'Cor de ação principal',
    ['setting_accent_hover'] = 'Destaque ao Passar o Mouse',
    ['setting_accent_hover_desc'] = 'Cor do estado ao passar o mouse',
    ['setting_success'] = 'Cor de Sucesso',
    ['setting_success_desc'] = 'Ações de sucesso/concluído',
    ['setting_danger'] = 'Cor de Perigo',
    ['setting_danger_desc'] = 'Ações de excluir/aviso',
    ['setting_warning'] = 'Cor de Aviso',
    ['setting_warning_desc'] = 'Ações de aviso/alerta',
    ['setting_info'] = 'Cor de Informação',
    ['setting_info_desc'] = 'Exibições de informação',
    ['setting_bg_primary'] = 'Fundo Principal',
    ['setting_bg_primary_desc'] = 'Área de conteúdo principal',
    ['setting_bg_secondary'] = 'Fundo Secundário',
    ['setting_bg_secondary_desc'] = 'Cartões e painéis',
    ['setting_bg_tertiary'] = 'Fundo Terciário',
    ['setting_bg_tertiary_desc'] = 'Elementos aninhados',
    ['setting_sidebar_bg'] = 'Fundo da Barra Lateral',
    ['setting_sidebar_bg_desc'] = 'Barra lateral de navegação',
    ['setting_text_primary'] = 'Texto Principal',
    ['setting_text_primary_desc'] = 'Cor do texto principal',
    ['setting_text_secondary'] = 'Texto Secundário',
    ['setting_text_secondary_desc'] = 'Cor do texto secundário',
    ['setting_border'] = 'Cor da Borda',
    ['setting_border_desc'] = 'Cor da borda e divisor',
    ['setting_btn_primary'] = 'Botão Principal',
    ['setting_btn_primary_desc'] = 'Botões de ação principal',
    ['setting_btn_primary_hover'] = 'Botão Principal ao Passar o Mouse',
    ['setting_btn_primary_hover_desc'] = 'Estado do botão principal ao passar o mouse',
    ['setting_btn_secondary'] = 'Botão Secundário',
    ['setting_btn_secondary_desc'] = 'Botões de ação secundária',
    ['setting_btn_secondary_hover'] = 'Botão Secundário ao Passar o Mouse',
    ['setting_btn_secondary_hover_desc'] = 'Estado do botão secundário ao passar o mouse',
    ['setting_border_radius'] = 'Raio da Borda',
    ['setting_border_radius_desc'] = 'Arredondamento dos elementos',
    ['setting_card_shadow'] = 'Sombra do Cartão',
    ['setting_card_shadow_desc'] = 'Intensidade da sombra',
    
    -- Modals
    ['modal_delete_title'] = 'Excluir Tarefa',
    ['modal_delete_message'] = 'Tem certeza de que deseja excluir esta tarefa?',
    ['modal_delete_reason'] = 'Motivo da exclusão',
    ['modal_delete_placeholder'] = 'Digite o motivo...',
    ['modal_complete_title'] = 'Concluir Tarefa',
    ['modal_complete_message'] = 'Tem certeza de que deseja marcar esta tarefa como concluída?',
    ['modal_complete_reason'] = 'Motivo da conclusão',
    ['modal_complete_placeholder'] = 'Digite o motivo da conclusão...',
    ['modal_reopen_title'] = 'Reabrir Tarefa',
    ['modal_reopen_message'] = 'Tem certeza de que deseja reabrir esta tarefa?',
    ['modal_reopen_reason'] = 'Motivo da reabertura',
    ['modal_reopen_placeholder'] = 'Digite o motivo da reabertura...',
    ['modal_reset_title'] = 'Redefinir Configurações',
    ['modal_reset_message'] = 'Tem certeza de que deseja redefinir todas as configurações para os valores padrão? Isso não pode ser desfeito.',
    ['modal_priority_title'] = 'Alterar Prioridade',
    
    -- Empty States
    ['empty_no_tasks'] = 'Nenhuma tarefa encontrada',
    ['empty_no_pending'] = 'Nenhuma tarefa pendente',
    ['empty_no_completed'] = 'Nenhuma tarefa concluída',
    
    -- Notifications
    ['notif_task_created'] = 'Tarefa criada com sucesso',
    ['notif_task_deleted'] = 'Tarefa excluída com sucesso',
    ['notif_task_completed'] = 'Tarefa concluída com sucesso',
    ['notif_task_reopened'] = 'Tarefa reaberta com sucesso',
    ['notif_settings_saved'] = 'Configurações salvas com sucesso',
    ['notif_settings_reset'] = 'Configurações redefinidas para os valores padrão',
    ['notif_teleported'] = 'Teleportado para a localização da tarefa',
    ['notif_position_copied'] = 'Posição copiada para a área de transferência',
    ['notif_error'] = 'Ocorreu um erro',
    ['notif_permission_denied'] = 'Você não tem permissão para usar este sistema',
    ['notif_invalid_coords'] = 'Coordenadas inválidas',
    
    -- Validation
    ['validation_description_required'] = 'Por favor, digite uma descrição da tarefa',
    ['validation_form_error'] = 'Erro no formulário. Por favor, atualize e tente novamente.',
    
    -- Server Messages
    ['server_permission_denied'] = 'Você não tem permissão para adicionar tarefas',
    ['server_task_empty'] = 'A descrição da tarefa não pode estar vazia',
    ['server_task_failed'] = 'Falha ao criar a tarefa. Por favor, tente novamente.',
}

