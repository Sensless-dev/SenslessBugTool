// Admin To-Do System UI JavaScript

let currentTheme = 'dark';
let tasks = [];
let currentTab = 'pending';
let currentPriorityFilter = 'all';
let confirmCallback = null;
let priorityChangeTaskId = null;
let reopenTaskId = null;
let completeTaskId = null;
let deleteTaskId = null;
let pendingTabSwitch = null; // Track pending tab switch after task update

// Auto-refresh interval
let autoRefreshInterval = null;

// Start auto-refresh every 10 seconds
function startAutoRefresh() {
    // Clear any existing interval
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
    }
    
    // Refresh every 10 seconds (10000ms)
    autoRefreshInterval = setInterval(() => {
        // Only refresh if UI is open and we're on a task-related tab
        const app = document.getElementById('app');
        if (app && !app.classList.contains('hidden')) {
            if (currentTab === 'pending' || currentTab === 'completed') {
                refreshTasks();
            } else if (currentTab === 'resources') {
                refreshResources();
            } else if (currentTab === 'lounge') {
                refreshChat();
            }
        }
    }, 10000); // 10 seconds
}

// Stop auto-refresh (when UI closes)
function stopAutoRefresh() {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
        autoRefreshInterval = null;
    }
}

// Prevent any external window opening
window.open = function() {
    console.warn('Blocked attempt to open external window');
    return null;
};

// Block browser dialogs that open external windows
window.alert = function(message) {
    console.warn('Blocked alert dialog:', message);
    // Use in-game notification instead
    if (typeof showNotification === 'function') {
        showNotification('info', message);
    }
};

window.confirm = function(message) {
    console.warn('Blocked confirm dialog:', message);
    // Return false by default - use showConfirm() for in-game modals instead
    return false;
};

window.prompt = function(message, defaultValue) {
    console.warn('Blocked prompt dialog:', message);
    // Return null by default - use custom modals for input instead
    return null;
};

// Ensure we're in NUI context (not external browser)
if (typeof GetParentResourceName === 'undefined') {
    console.error('Not running in NUI context! This UI should only run in-game.');
}

// Initialize
window.addEventListener('DOMContentLoaded', function() {
    setupEventListeners();
    loadSettings(); // Load saved settings on page load
});

// Localization
let currentLocale = 'en';
let locales = {};

// Get localized string
function L(key, ...args) {
    let text = locales[key] || key;
    if (args.length > 0) {
        args.forEach((arg, index) => {
            text = text.replace(`{${index}}`, arg);
        });
    }
    return text;
}

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openUI':
            // Load localization
            if (data.locale) {
                currentLocale = data.locale;
            }
            if (data.locales) {
                locales = data.locales;
                console.log('Loaded locales for:', currentLocale, 'Keys:', Object.keys(locales).length);
            }
            openUI(data.theme, data.resourceName);
            break;
        case 'updateTasks':
            updateTasks(data.tasks);
            break;
        case 'forceClose':
            closeUI();
            break;
        case 'updateChat':
            console.log('Received updateChat action with messages:', data.messages);
            if (data.messages) {
                displayChatMessages(data.messages);
            } else {
                console.warn('updateChat received but no messages in data');
            }
            break;
        case 'newChatMessage':
            console.log('Received newChatMessage action:', data);
            if (data.message) {
                console.log('Displaying new message:', data.message);
                displayChatMessage(data.message);
            } else {
                console.warn('newChatMessage received but no message in data');
            }
            break;
        case 'receiveResources':
            if (data.resources) {
                populateResourceDropdown(data.resources);
            }
            break;
        case 'receiveResourcesList':
            if (data.resources) {
                displayResources(data.resources);
            }
            break;
    }
});

// Setup Event Listeners
function setupEventListeners() {
    // Close button
    document.getElementById('closeBtn').addEventListener('click', closeUI);
    
    // Refresh button
    document.getElementById('refreshBtn').addEventListener('click', function() {
        if (currentTab === 'resources') {
            refreshResources();
        } else {
            refreshTasks();
        }
    });
    
    // Navigation items
    document.querySelectorAll('.nav-item').forEach(navItem => {
        navItem.addEventListener('click', function() {
            switchTab(this.dataset.tab);
        });
    });
    
    // Priority filter buttons
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            // Update active state
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            // Update filter
            currentPriorityFilter = this.getAttribute('data-priority');
            renderTasks();
        });
    });
    
    // Chat input
    const chatInput = document.getElementById('chatInput');
    const sendChatBtn = document.getElementById('sendChatBtn');
    
    if (chatInput && sendChatBtn) {
        sendChatBtn.addEventListener('click', sendChatMessage);
        chatInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendChatMessage();
            }
        });
    }
    
    // Add task button
    document.getElementById('addTaskBtn').addEventListener('click', openAddTaskModal);
    
    // Settings event listeners
    setupSettingsListeners();
    
    // Task action buttons (event delegation for dynamically created elements)
    document.addEventListener('click', function(e) {
        if (e.target.closest('.task-action-btn')) {
            const btn = e.target.closest('.task-action-btn');
            const action = btn.getAttribute('data-action');
            const taskId = parseInt(btn.getAttribute('data-task-id'));
            
            if (!taskId) return;
            
            switch(action) {
                case 'complete':
                    completeTask(taskId);
                    break;
                case 'priority':
                    changePriority(taskId);
                    break;
                case 'delete':
                    deleteTask(taskId);
                    break;
                case 'reopen':
                    reopenTask(taskId);
                    break;
                case 'details':
                    viewTaskDetails(taskId);
                    break;
            }
        }
    });
    
    // Modal close buttons
    document.getElementById('closeModalBtn').addEventListener('click', closeAddTaskModal);
    const closeResourceFilesModalBtn = document.getElementById('closeResourceFilesModalBtn');
    const closeResourceFilesBtn = document.getElementById('closeResourceFilesBtn');
    if (closeResourceFilesModalBtn) {
        closeResourceFilesModalBtn.addEventListener('click', closeResourceFilesModal);
    }
    if (closeResourceFilesBtn) {
        closeResourceFilesBtn.addEventListener('click', closeResourceFilesModal);
    }
    document.getElementById('closeDetailsModalBtn').addEventListener('click', closeTaskDetailsModal);
    document.getElementById('cancelTaskBtn').addEventListener('click', closeAddTaskModal);
    
    // Submit task
    document.getElementById('submitTaskBtn').addEventListener('click', submitTask);
    
    // Confirmation modal buttons
    document.getElementById('confirmOkBtn').addEventListener('click', function() {
        if (confirmCallback) {
            confirmCallback(true);
            confirmCallback = null;
        }
        closeConfirmModal();
    });
    
    document.getElementById('confirmCancelBtn').addEventListener('click', function() {
        if (confirmCallback) {
            confirmCallback(false);
            confirmCallback = null;
        }
        closeConfirmModal();
    });
    
    document.getElementById('confirmModal').addEventListener('click', function(e) {
        if (e.target === this) {
            if (confirmCallback) {
                confirmCallback(false);
                confirmCallback = null;
            }
            closeConfirmModal();
        }
    });
    
    // Priority modal buttons (check if elements exist)
    const closePriorityModalBtn = document.getElementById('closePriorityModalBtn');
    const priorityCancelBtn = document.getElementById('priorityCancelBtn');
    const priorityConfirmBtn = document.getElementById('priorityConfirmBtn');
    const priorityModal = document.getElementById('priorityModal');
    
    if (closePriorityModalBtn) {
        closePriorityModalBtn.addEventListener('click', closePriorityModal);
    }
    if (priorityCancelBtn) {
        priorityCancelBtn.addEventListener('click', closePriorityModal);
    }
    if (priorityConfirmBtn) {
        priorityConfirmBtn.addEventListener('click', confirmPriorityChange);
    }
    if (priorityModal) {
        priorityModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closePriorityModal();
            }
        });
    }
    
    // Reopen modal buttons
    const closeReopenModalBtn = document.getElementById('closeReopenModalBtn');
    const reopenCancelBtn = document.getElementById('reopenCancelBtn');
    const reopenConfirmBtn = document.getElementById('reopenConfirmBtn');
    const reopenModal = document.getElementById('reopenModal');
    
    if (closeReopenModalBtn) {
        closeReopenModalBtn.addEventListener('click', closeReopenModal);
    }
    if (reopenCancelBtn) {
        reopenCancelBtn.addEventListener('click', closeReopenModal);
    }
    if (reopenConfirmBtn) {
        reopenConfirmBtn.addEventListener('click', confirmReopenTask);
    }
    if (reopenModal) {
        reopenModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeReopenModal();
            }
        });
    }
    
    // Complete modal buttons
    const closeCompleteModalBtn = document.getElementById('closeCompleteModalBtn');
    const completeCancelBtn = document.getElementById('completeCancelBtn');
    const completeConfirmBtn = document.getElementById('completeConfirmBtn');
    const completeModal = document.getElementById('completeModal');
    
    if (closeCompleteModalBtn) {
        closeCompleteModalBtn.addEventListener('click', closeCompleteModal);
    }
    if (completeCancelBtn) {
        completeCancelBtn.addEventListener('click', closeCompleteModal);
    }
    if (completeConfirmBtn) {
        completeConfirmBtn.addEventListener('click', confirmCompleteTask);
    }
    if (completeModal) {
        completeModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeCompleteModal();
            }
        });
    }
    
    // Delete modal buttons
    const closeDeleteModalBtn = document.getElementById('closeDeleteModalBtn');
    const deleteCancelBtn = document.getElementById('deleteCancelBtn');
    const deleteConfirmBtn = document.getElementById('deleteConfirmBtn');
    const deleteModal = document.getElementById('deleteModal');
    
    if (closeDeleteModalBtn) {
        closeDeleteModalBtn.addEventListener('click', closeDeleteModal);
    }
    if (deleteCancelBtn) {
        deleteCancelBtn.addEventListener('click', closeDeleteModal);
    }
    if (deleteConfirmBtn) {
        deleteConfirmBtn.addEventListener('click', confirmDeleteTask);
    }
    if (deleteModal) {
        deleteModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });
    }
    
    // Close modal on background click
    document.getElementById('addTaskModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAddTaskModal();
        }
    });
    
    document.getElementById('taskDetailsModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeTaskDetailsModal();
        }
    });
    
    // ESC key to close modals and UI
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // Close confirmation modal first
            if (!document.getElementById('confirmModal').classList.contains('hidden')) {
                closeConfirmModal();
                return;
            }
            // Close priority modal
            const priorityModal = document.getElementById('priorityModal');
            if (priorityModal && !priorityModal.classList.contains('hidden')) {
                closePriorityModal();
                return;
            }
            // Close reopen modal
            const reopenModal = document.getElementById('reopenModal');
            if (reopenModal && !reopenModal.classList.contains('hidden')) {
                closeReopenModal();
                return;
            }
            // Close complete modal
            const completeModal = document.getElementById('completeModal');
            if (completeModal && !completeModal.classList.contains('hidden')) {
                closeCompleteModal();
                return;
            }
            // Close delete modal
            const deleteModal = document.getElementById('deleteModal');
            if (deleteModal && !deleteModal.classList.contains('hidden')) {
                closeDeleteModal();
                return;
            }
            // Close other modals
            closeAddTaskModal();
            closeTaskDetailsModal();
            // If no modals are open, close the main UI
            if (document.getElementById('addTaskModal').classList.contains('hidden') && 
                document.getElementById('taskDetailsModal').classList.contains('hidden')) {
                closeUI();
            }
        }
    });
}

// Apply translations to UI elements
function applyTranslations() {
    // Update app title and subtitle
    const appTitle = document.querySelector('.logo-text h1');
    const appSubtitle = document.querySelector('.logo-text p');
    if (appTitle) appTitle.textContent = L('app_title');
    if (appSubtitle) appSubtitle.textContent = L('app_subtitle');
    
    // Update navigation items
    const navPending = document.querySelector('[data-tab="pending"] span:not(.nav-badge)');
    const navCompleted = document.querySelector('[data-tab="completed"] span:not(.nav-badge)');
    const navResources = document.querySelector('[data-tab="resources"] span');
    const navLounge = document.querySelector('[data-tab="lounge"] span');
    const navSettings = document.querySelector('[data-tab="settings"] span');
    
    if (navPending) navPending.textContent = L('nav_pending');
    if (navCompleted) navCompleted.textContent = L('nav_completed');
    if (navResources) navResources.textContent = L('nav_resources');
    if (navLounge) navLounge.textContent = L('nav_lounge');
    if (navSettings) navSettings.textContent = L('nav_settings');
    
    // Update buttons
    const createTaskBtn = document.getElementById('addTaskBtn');
    if (createTaskBtn) {
        // Find text node after SVG and update it
        const svg = createTaskBtn.querySelector('svg');
        if (svg && svg.nextSibling) {
            // Update existing text node
            if (svg.nextSibling.nodeType === 3) {
                svg.nextSibling.textContent = ' ' + L('btn_create_task');
            } else {
                // If it's an element, update its text
                svg.nextSibling.textContent = L('btn_create_task');
            }
        } else if (svg) {
            // Create text node if it doesn't exist
            createTaskBtn.appendChild(document.createTextNode(' ' + L('btn_create_task')));
        }
    }
    
    const refreshBtn = document.getElementById('refreshBtn');
    if (refreshBtn) refreshBtn.setAttribute('title', L('btn_refresh'));
    
    // Update filter labels
    const filterLabel = document.querySelector('.filter-label');
    if (filterLabel) filterLabel.textContent = L('filter_label');
    
    const filterAll = document.querySelector('[data-priority="all"]');
    const filterHigh = document.querySelector('[data-priority="high"]');
    const filterNormal = document.querySelector('[data-priority="normal"]');
    const filterLow = document.querySelector('[data-priority="low"]');
    
    if (filterAll) filterAll.textContent = L('priority_all');
    if (filterHigh) filterHigh.textContent = L('priority_high');
    if (filterNormal) filterNormal.textContent = L('priority_normal');
    if (filterLow) filterLow.textContent = L('priority_low');
    
    // Update page titles (will be updated when switching tabs)
    switchTab(currentTab || 'pending');
}

// Open UI
function openUI(theme, resName) {
    if (resName) {
        resourceName = resName;
        console.log('Resource name set from client:', resourceName);
    } else {
        // Re-initialize if not provided
        initializeResourceName();
        console.log('Resource name detected:', resourceName);
    }
    currentTheme = theme || 'dark';
    document.body.className = currentTheme + '-theme';
    document.getElementById('app').classList.remove('hidden');
    
    // Apply translations after UI is shown
    applyTranslations();
    
    refreshTasks();
    
    // Start auto-refresh when UI opens
    startAutoRefresh();
}

// Close UI
function closeUI() {
    // Stop auto-refresh when closing
    stopAutoRefresh();
    
    // Reset settings update flag to prevent stuck state
    isUpdatingSettings = false;
    
    // Always hide the UI first
    const app = document.getElementById('app');
    if (app) {
        app.classList.add('hidden');
    }
    
    // Then notify the client to release focus (don't wait for response)
    try {
        const resource = GetParentResourceName();
        // Use fetch with keepalive for reliable delivery
        fetch(`https://${resource}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({}),
            keepalive: true
        }).catch(() => {
            // Silently fail - UI is already hidden, focus will be released by resource stop handler if needed
        });
    } catch (err) {
        // Silently fail - UI is already hidden
    }
}

// Switch Tab
function switchTab(tab) {
    try {
        currentTab = tab;
        
        // Update navigation items
        document.querySelectorAll('.nav-item').forEach(nav => {
            nav.classList.remove('active');
        });
        const navButton = document.querySelector(`[data-tab="${tab}"]`);
        if (navButton) {
            navButton.classList.add('active');
        }
        
        // Update page title and subtitle
        const pageTitle = document.getElementById('pageTitle');
        const pageSubtitle = document.getElementById('pageSubtitle');
        
        const titles = {
            'pending': { title: L('page_pending_title'), subtitle: L('page_pending_subtitle') },
            'completed': { title: L('page_completed_title'), subtitle: L('page_completed_subtitle') },
            'resources': { title: L('page_resources_title'), subtitle: L('page_resources_subtitle') },
            'lounge': { title: L('page_lounge_title'), subtitle: L('page_lounge_subtitle') },
            'settings': { title: L('page_settings_title'), subtitle: L('page_settings_subtitle') }
        };
        
        if (pageTitle && titles[tab]) {
            pageTitle.textContent = titles[tab].title;
        }
        if (pageSubtitle && titles[tab]) {
            pageSubtitle.textContent = titles[tab].subtitle;
        }
        
        // Update task lists, resources, lounge, and settings
        const pendingList = document.getElementById('pendingTasks');
        const completedList = document.getElementById('completedTasks');
        const resourcesList = document.getElementById('resourcesList');
        const loungeContainer = document.getElementById('loungeContainer');
        const settingsContainer = document.getElementById('settingsContainer');
        const priorityFilter = document.getElementById('priorityFilter');
        
        if (pendingList) {
            pendingList.classList.toggle('active', tab === 'pending');
        }
        if (completedList) {
            completedList.classList.toggle('active', tab === 'completed');
        }
        if (resourcesList) {
            resourcesList.classList.toggle('active', tab === 'resources');
            if (tab === 'resources') {
                refreshResources();
            }
        }
        if (loungeContainer) {
            if (tab === 'lounge') {
                loungeContainer.classList.remove('hidden');
                loungeContainer.classList.add('active');
            } else {
                loungeContainer.classList.add('hidden');
                loungeContainer.classList.remove('active');
            }
        }
        if (settingsContainer) {
            if (tab === 'settings') {
                settingsContainer.classList.remove('hidden');
                settingsContainer.classList.add('active');
                loadSettings(); // Load saved settings when opening
            } else {
                settingsContainer.classList.add('hidden');
                settingsContainer.classList.remove('active');
            }
        }
        
        // Show/hide priority filter (only for task tabs)
        if (priorityFilter) {
            priorityFilter.style.display = (tab === 'pending' || tab === 'completed') ? 'flex' : 'none';
        }
        
        // Hide create task button on settings tab
        const addTaskBtn = document.getElementById('addTaskBtn');
        if (addTaskBtn) {
            addTaskBtn.style.display = (tab === 'settings') ? 'none' : 'flex';
        }
        
        // If switching to lounge, refresh chat and ensure container is visible
        if (tab === 'lounge') {
            // Small delay to ensure container is visible
            setTimeout(() => {
                refreshChat();
            }, 100);
        }
        
        renderTasks();
        
        // Ensure all tasks in the active tab are visible after switch
        setTimeout(() => {
            const activeContainer = tab === 'pending' 
                ? document.getElementById('pendingTasks')
                : tab === 'completed'
                ? document.getElementById('completedTasks')
                : null;
            if (activeContainer) {
                activeContainer.querySelectorAll('.task-item').forEach(el => {
                    el.style.opacity = '1';
                    el.style.transform = '';
                });
            }
        }, 200);
    } catch (err) {
        console.error('Error switching tab:', err);
    }
}

// Update Tasks
function updateTasks(newTasks) {
    // Save scroll positions before update
    const pendingContainer = document.getElementById('pendingTasks');
    const completedContainer = document.getElementById('completedTasks');
    const pendingScroll = pendingContainer ? pendingContainer.scrollTop : 0;
    const completedScroll = completedContainer ? completedContainer.scrollTop : 0;
    
    tasks = newTasks || [];
    
    // Use requestAnimationFrame for smooth update
    requestAnimationFrame(() => {
        renderTasks();
        
        // Restore scroll positions after render
        if (pendingContainer) {
            pendingContainer.scrollTop = pendingScroll;
        }
        if (completedContainer) {
            completedContainer.scrollTop = completedScroll;
        }
        
        // If there's a pending tab switch, do it now that tasks are updated
        if (pendingTabSwitch) {
            const tabToSwitch = pendingTabSwitch;
            pendingTabSwitch = null;
            setTimeout(() => {
                switchTab(tabToSwitch);
                // Force all tasks to be visible after tab switch
                setTimeout(() => {
                    const activeContainer = tabToSwitch === 'pending' 
                        ? document.getElementById('pendingTasks')
                        : document.getElementById('completedTasks');
                    if (activeContainer) {
                        activeContainer.querySelectorAll('.task-item').forEach(el => {
                            el.style.opacity = '1';
                            el.style.transform = '';
                            el.style.transition = '';
                        });
                    }
                }, 300);
            }, 100);
        }
    });
    
    // Update badge counts immediately with smooth transition
    const pendingBadge = document.getElementById('pendingBadge');
    const completedBadge = document.getElementById('completedBadge');
    if (pendingBadge) {
        const newCount = tasks.filter(t => t.status === 'pending').length;
        if (pendingBadge.textContent !== newCount.toString()) {
            pendingBadge.style.opacity = '0.5';
            setTimeout(() => {
                pendingBadge.textContent = newCount;
                pendingBadge.style.opacity = '1';
            }, 150);
        }
    }
    if (completedBadge) {
        const newCount = tasks.filter(t => t.status === 'completed').length;
        if (completedBadge.textContent !== newCount.toString()) {
            completedBadge.style.opacity = '0.5';
            setTimeout(() => {
                completedBadge.textContent = newCount;
                completedBadge.style.opacity = '1';
            }, 150);
        }
    }
}

// Render Tasks
function renderTasks() {
    const pendingContainer = document.getElementById('pendingTasks');
    const completedContainer = document.getElementById('completedTasks');
    
    let pendingTasks = tasks.filter(t => t.status === 'pending');
    let completedTasks = tasks.filter(t => t.status === 'completed');
    
    // Apply priority filter
    if (currentPriorityFilter !== 'all') {
        pendingTasks = pendingTasks.filter(t => (t.priority || 'normal') === currentPriorityFilter);
        completedTasks = completedTasks.filter(t => (t.priority || 'normal') === currentPriorityFilter);
    }
    
    // Update badge counts
    const pendingBadge = document.getElementById('pendingBadge');
    const completedBadge = document.getElementById('completedBadge');
    if (pendingBadge) {
        pendingBadge.textContent = tasks.filter(t => t.status === 'pending').length;
    }
    if (completedBadge) {
        completedBadge.textContent = tasks.filter(t => t.status === 'completed').length;
    }
    
    // Check if containers are empty (initial load) - use simple render
    const hasExistingPending = pendingContainer && pendingContainer.querySelectorAll('.task-item').length > 0;
    const hasExistingCompleted = completedContainer && completedContainer.querySelectorAll('.task-item').length > 0;
    
    // If no existing tasks, do a simple render first, then use smooth updates
    if (!hasExistingPending && !hasExistingCompleted && (pendingTasks.length > 0 || completedTasks.length > 0)) {
        // Initial render - show tasks immediately
        if (pendingContainer) {
            pendingContainer.innerHTML = '';
            pendingTasks.forEach(task => {
                const taskEl = createTaskElement(task);
                pendingContainer.appendChild(taskEl);
            });
            if (pendingTasks.length === 0) {
                pendingContainer.innerHTML = `
                    <div class="empty-state" id="pendingEmpty">
                        <div class="empty-icon">📝</div>
                        <h3>No pending tasks${currentPriorityFilter !== 'all' ? ' with ' + currentPriorityFilter + ' priority' : ''}</h3>
                        <p>All caught up! Create a new task to get started.</p>
                    </div>
                `;
            }
        }
        
        if (completedContainer) {
            completedContainer.innerHTML = '';
            completedTasks.forEach(task => {
                const taskEl = createTaskElement(task);
                completedContainer.appendChild(taskEl);
            });
            if (completedTasks.length === 0) {
                completedContainer.innerHTML = `
                    <div class="empty-state" id="completedEmpty">
                        <div class="empty-icon">✅</div>
                        <h3>No completed tasks${currentPriorityFilter !== 'all' ? ' with ' + currentPriorityFilter + ' priority' : ''}</h3>
                        <p>Completed tasks will appear here.</p>
                    </div>
                `;
            }
        }
    } else {
        // Use smooth updates for subsequent renders
        updateTaskList(pendingContainer, pendingTasks, 'pending');
        updateTaskList(completedContainer, completedTasks, 'completed');
    }
}

// Smoothly update task list without flickering
function updateTaskList(container, newTasks, type) {
    if (!container) return;
    
    const existingTasks = Array.from(container.querySelectorAll('.task-item'));
    const existingTaskIds = new Set(existingTasks.map(el => {
        const taskId = el.getAttribute('data-task-id');
        return taskId ? parseInt(taskId) : null;
    }).filter(id => id !== null));
    
    const newTaskIds = new Set(newTasks.map(t => t.id));
    
    // Remove tasks that no longer exist (with fade out)
    existingTasks.forEach(taskEl => {
        const taskId = taskEl.getAttribute('data-task-id');
        const id = taskId ? parseInt(taskId) : null;
        if (id && !newTaskIds.has(id)) {
            taskEl.style.transition = 'opacity 0.2s ease, transform 0.2s ease';
            taskEl.style.opacity = '0';
            taskEl.style.transform = 'translateY(-10px)';
            setTimeout(() => {
                if (taskEl.parentNode) {
                    taskEl.parentNode.removeChild(taskEl);
                }
            }, 200);
        }
    });
    
    // Update or add tasks
    if (newTasks.length === 0) {
        // Show empty state if no tasks
        const existingEmpty = container.querySelector('.empty-state');
        const existingTaskItems = container.querySelectorAll('.task-item');
        if (!existingEmpty && existingTaskItems.length === 0) {
            const emptyDiv = document.createElement('div');
            emptyDiv.className = 'empty-state';
            emptyDiv.id = type + 'Empty';
            emptyDiv.innerHTML = `
                <div class="empty-icon">${type === 'pending' ? '📝' : '✅'}</div>
                <h3>No ${type} tasks${currentPriorityFilter !== 'all' ? ' with ' + currentPriorityFilter + ' priority' : ''}</h3>
                <p>${type === 'pending' ? 'All caught up! Create a new task to get started.' : 'Completed tasks will appear here.'}</p>
            `;
            emptyDiv.style.opacity = '0';
            container.appendChild(emptyDiv);
            requestAnimationFrame(() => {
                emptyDiv.style.transition = 'opacity 0.3s ease';
                emptyDiv.style.opacity = '1';
            });
        }
    } else {
        // Remove empty state if it exists
        const emptyState = container.querySelector('.empty-state');
        if (emptyState) {
            emptyState.style.transition = 'opacity 0.2s ease';
            emptyState.style.opacity = '0';
            setTimeout(() => {
                if (emptyState.parentNode) {
                    emptyState.parentNode.removeChild(emptyState);
                }
            }, 200);
        }
        
        // Create a document fragment for batch insertion
        const fragment = document.createDocumentFragment();
        const existingElements = new Map();
        
        // Map existing task elements by ID
        existingTasks.forEach(el => {
            const taskId = el.getAttribute('data-task-id');
            const id = taskId ? parseInt(taskId) : null;
            if (id) {
                existingElements.set(id, el);
            }
        });
        
        // Update or create tasks
        newTasks.forEach((task, index) => {
            const existingEl = existingElements.get(task.id);
            if (existingEl) {
                // Check if task needs update by comparing key properties
                const needsUpdate = checkTaskNeedsUpdate(existingEl, task);
                if (needsUpdate) {
                    // Update existing element in place without opacity animation to prevent flashing
                    const newEl = createTaskElement(task);
                    // Set opacity to 1 immediately to prevent flash
                    newEl.style.opacity = '1';
                    newEl.style.transform = '';
                    existingEl.parentNode.replaceChild(newEl, existingEl);
                } else {
                    // Ensure existing element is visible and stays visible
                    existingEl.style.opacity = '1';
                    existingEl.style.transform = '';
                }
            } else {
                // Add new element with fade in (only for truly new tasks)
                const newEl = createTaskElement(task);
                newEl.style.opacity = '0';
                newEl.style.transform = 'translateY(-10px)';
                fragment.appendChild(newEl);
            }
        });
        
        // Append new elements
        if (fragment.children.length > 0) {
            container.appendChild(fragment);
            // Animate new elements in
            Array.from(fragment.children).forEach((el, index) => {
                setTimeout(() => {
                    el.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                    el.style.opacity = '1';
                    el.style.transform = 'translateY(0)';
                    // Ensure visibility even if animation fails
                    setTimeout(() => {
                        el.style.opacity = '1';
                        el.style.transform = '';
                    }, 350);
                }, index * 20); // Stagger animation
            });
        }
        
        // Ensure all visible tasks have opacity 1 (safety check)
        setTimeout(() => {
            container.querySelectorAll('.task-item').forEach(el => {
                if (el.offsetParent !== null) { // Element is visible
                    el.style.opacity = '1';
                    el.style.transform = '';
                }
            });
        }, 500);
    }
}

// Check if task element needs update
function checkTaskNeedsUpdate(element, task) {
    // Only update if something actually changed to prevent flashing
    // Check priority badge
    const priorityEl = element.querySelector('.task-priority');
    const currentPriority = task.priority || 'normal';
    if (priorityEl && !priorityEl.classList.contains('priority-' + currentPriority)) {
        return true;
    }
    
    // Check status badge
    const statusEl = element.querySelector('.task-status');
    if (statusEl && !statusEl.classList.contains(task.status)) {
        return true;
    }
    
    // Check if description changed (simplified check)
    const descEl = element.querySelector('.task-description');
    if (descEl && descEl.textContent.trim() !== task.description.trim()) {
        return true;
    }
    
    return false;
}

// Create Task Element
function createTaskElement(task) {
    const taskDiv = document.createElement('div');
    taskDiv.className = 'task-item' + (task.status === 'completed' ? ' completed' : '');
    taskDiv.setAttribute('data-task-id', task.id);
    
    const dateCreated = formatDate(task.date_created);
    const dateCompleted = task.date_completed ? formatDate(task.date_completed) : null;
    
    const priority = task.priority || 'normal';
    const priorityLabels = {
        'low': 'Low',
        'normal': 'Normal',
        'high': 'High',
        'urgent': 'Urgent',
        'started': 'Started'
    };
    
    const taskTitle = task.title ? escapeHtml(task.title) : '';
    taskDiv.innerHTML = `
        <div class="task-header">
            <div class="task-title-row">
                <span class="task-id">#${task.id}</span>
                ${taskTitle ? `<span class="task-title">${taskTitle}</span>` : ''}
            </div>
            <div class="task-badges">
                <span class="task-priority priority-${priority}">${priorityLabels[priority] || 'Normal'}</span>
                <span class="task-status ${task.status}">${task.status}</span>
            </div>
        </div>
        <div class="task-description">${escapeHtml(task.description)}</div>
        <div class="task-meta">
            <div class="task-meta-item">
                <span>👤</span>
                <span>Created by: ${escapeHtml(task.created_by_name || 'Unknown')}</span>
            </div>
            ${task.assigned_to_name ? `
                <div class="task-meta-item">
                    <span>➡️</span>
                    <span>Assigned to: ${escapeHtml(task.assigned_to_name)}</span>
                </div>
            ` : ''}
            ${task.resource ? `
                <div class="task-meta-item">
                    <span>📦</span>
                    <span>Resource: <strong>${escapeHtml(task.resource)}</strong></span>
                </div>
            ` : ''}
            <div class="task-meta-item">
                <span>📅</span>
                <span>Created: ${dateCreated}</span>
            </div>
            ${dateCompleted ? `
                <div class="task-meta-item">
                    <span>✅</span>
                    <span>Completed: ${dateCompleted}</span>
                </div>
            ` : ''}
            ${task.reopen_reason ? `
                <div class="task-meta-item reopen-reason">
                    <span>🔄</span>
                    <span><strong>Reopened:</strong> ${escapeHtml(task.reopen_reason)}</span>
                </div>
            ` : ''}
        </div>
        ${task.status === 'pending' ? `
            <div class="task-actions">
                <button class="btn btn-success btn-sm task-action-btn" data-action="complete" data-task-id="${task.id}">
                    ✓ Complete
                </button>
                <button class="btn btn-primary btn-sm task-action-btn" data-action="priority" data-task-id="${task.id}">
                    ⚡ Priority
                </button>
                <button class="btn btn-danger btn-sm task-action-btn" data-action="delete" data-task-id="${task.id}">
                    🗑️ Delete
                </button>
                <button class="btn btn-secondary btn-sm task-action-btn" data-action="details" data-task-id="${task.id}">
                    👁️ Details
                </button>
            </div>
        ` : `
            <div class="task-actions">
                <button class="btn btn-primary btn-sm task-action-btn" data-action="reopen" data-task-id="${task.id}">
                    🔄 Reopen Task
                </button>
                <button class="btn btn-danger btn-sm task-action-btn" data-action="delete" data-task-id="${task.id}">
                    🗑️ Delete
                </button>
                <button class="btn btn-secondary btn-sm task-action-btn" data-action="details" data-task-id="${task.id}">
                    👁️ Details
                </button>
            </div>
        `}
    `;
    
    // Also make the entire task item clickable to view details
    taskDiv.addEventListener('click', function(e) {
        // Don't trigger if clicking on action buttons
        if (!e.target.closest('.task-actions')) {
            viewTaskDetails(task.id);
        }
    });
    
    return taskDiv;
}

// Format Date
function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Refresh Tasks (silent refresh - no visual disruption)
function refreshTasks() {
    const resource = GetParentResourceName();
    // Use a subtle loading indicator if needed, but don't disrupt the UI
    fetch(`https://${resource}/refreshTasks`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then((response) => {
        return response.text();
    }).catch(err => {
        console.error('Failed to refresh tasks:', err);
    });
}

// Open Add Task Modal
function openAddTaskModal() {
    document.getElementById('addTaskModal').classList.remove('hidden');
    const titleEl = document.getElementById('taskTitle');
    if (titleEl) {
        titleEl.value = '';
    }
    document.getElementById('taskDescription').focus();
    
    // Reset resource tasks info
    const resourceTasksInfo = document.getElementById('resourceTasksInfo');
    if (resourceTasksInfo) {
        resourceTasksInfo.classList.add('hidden');
        resourceTasksInfo.innerHTML = '';
    }
    
    // Request resources list from server
    const resource = GetParentResourceName();
    fetch(`https://${resource}/getResources`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then((response) => {
        return response.text();
    }).catch(err => {
        console.error('Failed to get resources:', err);
    });
    
    // Add event listener for resource selection change
    const resourceSelect = document.getElementById('taskResource');
    if (resourceSelect) {
        resourceSelect.onchange = function() {
            const selectedResource = this.value;
            if (selectedResource) {
                // Get tasks for this resource
                fetch(`https://${resource}/getResourceTasks`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        resourceName: selectedResource
                    })
                }).then((response) => {
                    return response.text();
                }).catch(err => {
                    console.error('Failed to get resource tasks:', err);
                });
            } else {
                // Hide resource tasks info
                if (resourceTasksInfo) {
                    resourceTasksInfo.classList.add('hidden');
                    resourceTasksInfo.innerHTML = '';
                }
            }
        };
    }
}

// Populate resource dropdown
function populateResourceDropdown(resources) {
    const resourceSelect = document.getElementById('taskResource');
    if (!resourceSelect) return;
    
    // Clear existing options except "None"
    resourceSelect.innerHTML = '<option value="">None</option>';
    
    // Add resources
    if (resources && resources.length > 0) {
        resources.forEach(resourceName => {
            const option = document.createElement('option');
            option.value = resourceName;
            option.textContent = resourceName;
            resourceSelect.appendChild(option);
        });
    }
}

// Close Add Task Modal
function closeAddTaskModal() {
    document.getElementById('addTaskModal').classList.add('hidden');
    document.getElementById('taskDescription').value = '';
    document.getElementById('taskAssignedTo').value = '';
    const taskPriority = document.getElementById('taskPriority');
    if (taskPriority) {
        taskPriority.value = 'normal';
    }
}

// Show in-game notification
function showNotification(type, message) {
    const resource = GetParentResourceName();
    fetch(`https://${resource}/showNotification`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            type: type,
            message: message
        })
    }).catch(err => {
        console.error('Failed to show notification:', err);
    });
}

// Show confirmation modal
function showConfirm(title, message, callback) {
    document.getElementById('confirmTitle').textContent = title || 'Confirm Action';
    document.getElementById('confirmMessage').textContent = message || 'Are you sure?';
    confirmCallback = callback;
    document.getElementById('confirmModal').classList.remove('hidden');
}

// Close confirmation modal
function closeConfirmModal() {
    document.getElementById('confirmModal').classList.add('hidden');
    confirmCallback = null;
}

// Submit Task
function submitTask() {
    const titleEl = document.getElementById('taskTitle');
    const descriptionEl = document.getElementById('taskDescription');
    const assignedToEl = document.getElementById('taskAssignedTo');
    const priorityEl = document.getElementById('taskPriority');
    const resourceEl = document.getElementById('taskResource');
    
    if (!descriptionEl) {
        console.error('Task description element not found');
        showNotification('error', 'Form error. Please refresh and try again.');
        return;
    }
    
    const title = titleEl ? titleEl.value.trim() : '';
    const description = descriptionEl.value.trim();
    const assignedTo = assignedToEl ? assignedToEl.value.trim() : '';
    const priority = priorityEl ? priorityEl.value : 'normal';
    const resourceValue = resourceEl ? resourceEl.value.trim() : '';
    
    if (!description) {
        showNotification('error', 'Please enter a task description');
        return;
    }
    
    const resourceName = GetParentResourceName();
    
    // Close modal first
    closeAddTaskModal();
    
    // Process resource value - "None" (empty string) should be sent as null
    let resource = null;
    if (resourceValue && resourceValue !== '' && resourceValue.toLowerCase() !== 'none') {
        resource = resourceValue;
    }
    
    // Submit task - convert empty strings to null for optional fields
    fetch(`https://${resourceName}/addTask`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            title: title || null,
            description: description,
            assignedTo: assignedTo || null,
            priority: priority || 'normal',
            resource: resource
        })
    }).then((response) => {
        return response.text();
    }).then((result) => {
        // Immediately refresh tasks after submission
        refreshTasks();
    }).catch(err => {
        console.error('Failed to add task:', err);
        showNotification('error', 'Failed to add task. Please try again.');
    });
}

// Complete Task
function completeTask(taskId) {
    if (!taskId) {
        console.error('Invalid task ID');
        return;
    }
    
    completeTaskId = taskId;
    const completeModal = document.getElementById('completeModal');
    const completeReasonInput = document.getElementById('completeReason');
    
    if (completeModal) {
        if (completeReasonInput) {
            completeReasonInput.value = '';
        }
        completeModal.classList.remove('hidden');
        if (completeReasonInput) {
            completeReasonInput.focus();
        }
    }
}

// Close Complete Modal
function closeCompleteModal() {
    const completeModal = document.getElementById('completeModal');
    if (completeModal) {
        completeModal.classList.add('hidden');
    }
    const completeReasonInput = document.getElementById('completeReason');
    if (completeReasonInput) {
        completeReasonInput.value = '';
    }
    completeTaskId = null;
}

// Confirm Complete Task
function confirmCompleteTask() {
    if (!completeTaskId) {
        console.error('CompleteTask: completeTaskId is null');
        closeCompleteModal();
        return;
    }
    
    const completeReasonInput = document.getElementById('completeReason');
    const completeReason = completeReasonInput ? completeReasonInput.value.trim() : '';
    
    if (!completeReason) {
        showNotification('error', 'Please provide a description of why this task is complete');
        return;
    }
    
    // Store taskId before closing modal
    const taskIdToComplete = parseInt(completeTaskId);
    console.log('CompleteTask: Sending taskId=' + taskIdToComplete + ', reason=' + completeReason);
    
    const resource = GetParentResourceName();
    closeCompleteModal();
    
    fetch(`https://${resource}/completeTask`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            taskId: taskIdToComplete,
            completeReason: completeReason
        })
    }).then((response) => {
        if (!response.ok) {
            throw new Error('Server returned an error');
        }
        return response.text();
    }).then((result) => {
        // Set pending tab switch - will happen when tasks are received
        pendingTabSwitch = 'completed';
        // Reset filter to 'all' so the completed task is visible
        currentPriorityFilter = 'all';
        // Update filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.getAttribute('data-priority') === 'all') {
                btn.classList.add('active');
            }
        });
        // Trigger refresh - the tab switch will happen in updateTasks when tasks arrive
        refreshTasks();
    }).catch(err => {
        console.error('Failed to complete task:', err);
        showNotification('error', 'Failed to complete task. Please try again.');
        pendingTabSwitch = null;
    });
}

// Reopen Task
function reopenTask(taskId) {
    if (!taskId) {
        console.error('Invalid task ID');
        return;
    }
    
    reopenTaskId = taskId;
    const reopenModal = document.getElementById('reopenModal');
    const reopenReasonInput = document.getElementById('reopenReason');
    
    if (reopenModal) {
        if (reopenReasonInput) {
            reopenReasonInput.value = '';
        }
        reopenModal.classList.remove('hidden');
        if (reopenReasonInput) {
            reopenReasonInput.focus();
        }
    }
}

// Close Reopen Modal
function closeReopenModal() {
    const reopenModal = document.getElementById('reopenModal');
    if (reopenModal) {
        reopenModal.classList.add('hidden');
    }
    const reopenReasonInput = document.getElementById('reopenReason');
    if (reopenReasonInput) {
        reopenReasonInput.value = '';
    }
    reopenTaskId = null;
}

// Confirm Reopen Task
function confirmReopenTask() {
    if (!reopenTaskId) {
        console.error('ReopenTask: reopenTaskId is null');
        closeReopenModal();
        return;
    }
    
    const reopenReasonInput = document.getElementById('reopenReason');
    const reopenReason = reopenReasonInput ? reopenReasonInput.value.trim() : '';
    
    if (!reopenReason) {
        showNotification('error', 'Please provide a reason for reopening the task');
        return;
    }
    
    // Store taskId before closing modal (which clears reopenTaskId)
    const taskIdToReopen = parseInt(reopenTaskId);
    console.log('ReopenTask: Sending taskId=' + taskIdToReopen + ', reason=' + reopenReason);
    
    const resource = GetParentResourceName();
    closeReopenModal();
    
    fetch(`https://${resource}/reopenTask`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            taskId: taskIdToReopen,
            reopenReason: reopenReason
        })
    }).then((response) => {
        if (!response.ok) {
            throw new Error('Server returned an error');
        }
        return response.text();
    }).then((result) => {
        // Set pending tab switch - will happen when tasks are received
        pendingTabSwitch = 'pending';
        // Reset filter to 'all' so the reopened task is visible
        currentPriorityFilter = 'all';
        // Update filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.getAttribute('data-priority') === 'all') {
                btn.classList.add('active');
            }
        });
        // Trigger refresh - the tab switch will happen in updateTasks when tasks arrive
        refreshTasks();
    }).catch(err => {
        console.error('Failed to reopen task:', err);
        showNotification('error', 'Failed to reopen task. Please try again.');
        pendingTabSwitch = null;
    });
}

// Change Priority
function changePriority(taskId) {
    const task = tasks.find(t => t.id === taskId);
    if (!task) return;
    
    const priorityModal = document.getElementById('priorityModal');
    if (!priorityModal) {
        showNotification('error', 'Priority modal not available');
        return;
    }
    
    priorityChangeTaskId = taskId;
    const currentPriority = task.priority || 'normal';
    const prioritySelect = document.getElementById('prioritySelect');
    
    // Set current priority in select
    if (prioritySelect) {
        prioritySelect.value = currentPriority;
    }
    
    // Show modal
    priorityModal.classList.remove('hidden');
}

// Close Priority Modal
function closePriorityModal() {
    const priorityModal = document.getElementById('priorityModal');
    if (priorityModal) {
        priorityModal.classList.add('hidden');
    }
    priorityChangeTaskId = null;
}

// Confirm Priority Change
function confirmPriorityChange() {
    if (!priorityChangeTaskId) {
        closePriorityModal();
        return;
    }
    
    const prioritySelect = document.getElementById('prioritySelect');
    const newPriority = prioritySelect ? prioritySelect.value : 'normal';
    
    const task = tasks.find(t => t.id === priorityChangeTaskId);
    if (!task) {
        closePriorityModal();
        return;
    }
    
    const currentPriority = task.priority || 'normal';
    
    if (newPriority === currentPriority) {
        showNotification('info', 'Priority is already set to ' + newPriority);
        closePriorityModal();
        return;
    }
    
    const resource = GetParentResourceName();
    fetch(`https://${resource}/updatePriority`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            taskId: priorityChangeTaskId,
            priority: newPriority
        })
    }).then((response) => {
        return response.text();
    }).then((result) => {
        const priorityLabels = {
            'low': 'Low',
            'normal': 'Normal',
            'high': 'High',
            'urgent': 'Urgent',
            'started': 'Started'
        };
        showNotification('success', 'Priority updated to ' + (priorityLabels[newPriority] || newPriority));
        closePriorityModal();
        setTimeout(() => refreshTasks(), 500);
    }).catch(err => {
        console.error('Failed to update priority:', err);
        showNotification('error', 'Failed to update priority. Please try again.');
        closePriorityModal();
    });
}

// Delete Task
function deleteTask(taskId) {
    if (!taskId) {
        console.error('Invalid task ID');
        return;
    }
    
    deleteTaskId = taskId;
    const deleteModal = document.getElementById('deleteModal');
    const deleteReasonInput = document.getElementById('deleteReason');
    
    if (deleteModal) {
        if (deleteReasonInput) {
            deleteReasonInput.value = '';
        }
        deleteModal.classList.remove('hidden');
        if (deleteReasonInput) {
            deleteReasonInput.focus();
        }
    }
}

// Close Delete Modal
function closeDeleteModal() {
    const deleteModal = document.getElementById('deleteModal');
    if (deleteModal) {
        deleteModal.classList.add('hidden');
    }
    const deleteReasonInput = document.getElementById('deleteReason');
    if (deleteReasonInput) {
        deleteReasonInput.value = '';
    }
    deleteTaskId = null;
}

// Confirm Delete Task
function confirmDeleteTask() {
    if (!deleteTaskId) {
        console.error('DeleteTask: deleteTaskId is null');
        closeDeleteModal();
        return;
    }
    
    const deleteReasonInput = document.getElementById('deleteReason');
    const deleteReason = deleteReasonInput ? deleteReasonInput.value.trim() : '';
    
    if (!deleteReason) {
        showNotification('error', 'Please provide a reason for deleting this task');
        return;
    }
    
    // Store taskId before closing modal
    const taskIdToDelete = parseInt(deleteTaskId);
    console.log('DeleteTask: Sending taskId=' + taskIdToDelete + ', reason=' + deleteReason);
    
    const resource = GetParentResourceName();
    closeDeleteModal();
    
    fetch(`https://${resource}/deleteTask`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            taskId: taskIdToDelete,
            deleteReason: deleteReason
        })
    }).then((response) => {
        if (!response.ok) {
            throw new Error('Server returned an error');
        }
        return response.text();
    }).then((result) => {
        setTimeout(() => refreshTasks(), 300);
    }).catch(err => {
        console.error('Failed to delete task:', err);
        showNotification('error', 'Failed to delete task. Please try again.');
    });
}

// View Task Details
function viewTaskDetails(taskId) {
    const task = tasks.find(t => t.id === taskId);
    if (!task) return;
    
    const modal = document.getElementById('taskDetailsModal');
    const body = document.getElementById('taskDetailsBody');
    const footer = document.getElementById('taskDetailsFooter');
    
    const dateCreated = formatDate(task.date_created);
    const dateCompleted = task.date_completed ? formatDate(task.date_completed) : null;
    
    const priority = task.priority || 'normal';
    const priorityLabels = {
        'low': 'Low',
        'normal': 'Normal',
        'high': 'High',
        'urgent': 'Urgent',
        'started': 'Started'
    };
    
    body.innerHTML = `
        <div class="task-details">
            <div class="form-group">
                <label>Task ID</label>
                <div>#${task.id}</div>
            </div>
            ${task.title ? `
                <div class="form-group">
                    <label>Title</label>
                    <div style="font-weight: 600; font-size: 16px; color: var(--text-primary);">${escapeHtml(task.title)}</div>
                </div>
            ` : ''}
            <div class="form-group">
                <label>Description</label>
                <div style="padding: 12px; background: var(--bg-secondary); border-radius: 6px; white-space: pre-wrap;">${escapeHtml(task.description)}</div>
            </div>
            <div class="form-group">
                <label>Status</label>
                <div><span class="task-status ${task.status}">${task.status}</span></div>
            </div>
            <div class="form-group">
                <label>Priority</label>
                <div>
                    <span class="task-priority priority-${task.priority || 'normal'}">${(task.priority && priorityLabels[task.priority]) ? priorityLabels[task.priority] : 'Normal'}</span>
                </div>
            </div>
            ${task.resource ? `
                <div class="form-group">
                    <label>Resource</label>
                    <div style="padding: 8px 12px; background: var(--bg-secondary); border-radius: 6px; border-left: 3px solid var(--accent-color);">
                        <strong style="color: var(--accent-color);">📦 ${escapeHtml(task.resource)}</strong>
                    </div>
                </div>
            ` : ''}
            ${task.position_x && task.position_y && task.position_z ? `
                <div class="form-group">
                    <label>Location (Vector4)</label>
                    <div style="padding: 16px; background: var(--bg-secondary); border-radius: 8px; border-left: 3px solid var(--info-color);">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                            <div style="flex: 1;">
                                <div style="font-weight: 600; margin-bottom: 8px; color: var(--text-primary); display: flex; align-items: center; gap: 6px;">
                                    <span>📍</span>
                                    <span>Coordinates</span>
                                </div>
                                <div style="font-family: 'Courier New', monospace; font-size: 13px; color: var(--text-secondary); background: var(--bg-primary); padding: 10px; border-radius: 6px; line-height: 1.8;">
                                    <div><strong>X:</strong> ${parseFloat(task.position_x).toFixed(2)}</div>
                                    <div><strong>Y:</strong> ${parseFloat(task.position_y).toFixed(2)}</div>
                                    <div><strong>Z:</strong> ${parseFloat(task.position_z).toFixed(2)}</div>
                                    ${task.position_heading ? `<div><strong>Heading:</strong> ${parseFloat(task.position_heading).toFixed(2)}</div>` : ''}
                                </div>
                                <div style="margin-top: 8px; font-family: 'Courier New', monospace; font-size: 12px; color: var(--text-muted); padding: 8px; background: var(--bg-primary); border-radius: 4px;">
                                    vector4(${parseFloat(task.position_x).toFixed(2)}, ${parseFloat(task.position_y).toFixed(2)}, ${parseFloat(task.position_z).toFixed(2)}, ${parseFloat(task.position_heading || 0).toFixed(2)})
                                </div>
                            </div>
                        </div>
                        <div style="display: flex; gap: 8px; margin-top: 12px;">
                            <button class="btn btn-sm btn-secondary" onclick="copyPosition(${parseFloat(task.position_x)}, ${parseFloat(task.position_y)}, ${parseFloat(task.position_z)}, ${parseFloat(task.position_heading || 0)})" style="flex: 1;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 4px;">
                                    <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                                    <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                                </svg>
                                Copy Vector4
                            </button>
                            <button class="btn btn-sm btn-primary" onclick="teleportToPosition(${parseFloat(task.position_x)}, ${parseFloat(task.position_y)}, ${parseFloat(task.position_z)}, ${parseFloat(task.position_heading || 0)})" style="flex: 1;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 4px;">
                                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                                    <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                                    <line x1="12" y1="22.08" x2="12" y2="12"></line>
                                </svg>
                                Teleport
                            </button>
                        </div>
                    </div>
                </div>
            ` : ''}
            <div class="form-group">
                <label>Created By</label>
                <div>${escapeHtml(task.created_by_name || 'Unknown')} (${escapeHtml(task.created_by)})</div>
            </div>
            ${task.assigned_to_name ? `
                <div class="form-group">
                    <label>Assigned To</label>
                    <div>${escapeHtml(task.assigned_to_name)} (${escapeHtml(task.assigned_to)})</div>
                </div>
            ` : ''}
            <div class="form-group">
                <label>Date Created</label>
                <div>${dateCreated}</div>
            </div>
            ${dateCompleted ? `
                <div class="form-group">
                    <label>Date Completed</label>
                    <div>${dateCompleted}</div>
                </div>
                <div class="form-group">
                    <label>Completed By</label>
                    <div>${escapeHtml(task.completed_by_name || 'Unknown')} (${escapeHtml(task.completed_by)})</div>
                </div>
            ` : ''}
            ${task.reopen_reason ? `
                <div class="form-group">
                    <label>Reopened Reason</label>
                    <div style="padding: 12px; background: rgba(255, 193, 7, 0.1); border-left: 3px solid var(--warning-color); border-radius: 6px; white-space: pre-wrap;">${escapeHtml(task.reopen_reason)}</div>
                </div>
            ` : ''}
        </div>
    `;
    
    footer.innerHTML = task.status === 'pending' ? `
        <button class="btn btn-success" onclick="completeTask(${task.id}); closeTaskDetailsModal();">
            ✓ Complete Task
        </button>
        <button class="btn btn-danger" onclick="deleteTask(${task.id}); closeTaskDetailsModal();">
            🗑️ Delete Task
        </button>
        <button class="btn btn-secondary" onclick="closeTaskDetailsModal()">
            Close
        </button>
    ` : `
        <button class="btn btn-primary" onclick="reopenTask(${task.id}); closeTaskDetailsModal();">
            🔄 Reopen Task
        </button>
        <button class="btn btn-danger" onclick="deleteTask(${task.id}); closeTaskDetailsModal();">
            🗑️ Delete Task
        </button>
        <button class="btn btn-secondary" onclick="closeTaskDetailsModal()">
            Close
        </button>
    `;
    
    modal.classList.remove('hidden');
}

// Close Task Details Modal
function closeTaskDetailsModal() {
    document.getElementById('taskDetailsModal').classList.add('hidden');
}

// Get Parent Resource Name
let resourceName = 'sensless_devtool';

// Initialize resource name
function initializeResourceName() {
    // Try native function first
    try {
        if (typeof GetParentResourceName === 'function') {
            const name = GetParentResourceName();
            if (name) {
                resourceName = name;
                return;
            }
        }
    } catch(e) {
        console.log('GetParentResourceName native not available');
    }
    
    // Try to get from script src
    try {
        const scripts = document.getElementsByTagName('script');
        for (let i = 0; i < scripts.length; i++) {
            if (scripts[i].src) {
                // Try nui:// format
                let match = scripts[i].src.match(/nui:\/\/[^\/]+\/([^\/]+)\/ui\.js/);
                if (!match) {
                    // Try https:// format
                    match = scripts[i].src.match(/https:\/\/cfx-nui-([^\/]+)\/ui\.js/);
                }
                if (match) {
                    resourceName = match[1];
                    break;
                }
            }
        }
    } catch(e) {
        console.log('Could not extract resource name from script src');
    }
}

// Initialize on load
initializeResourceName();

function GetParentResourceName() {
    return resourceName;
}

// Chat Functions
function sendChatMessage() {
    const chatInput = document.getElementById('chatInput');
    if (!chatInput) {
        console.error('Chat input not found');
        return;
    }
    
    const message = chatInput.value.trim();
    if (!message) {
        return;
    }
    
    if (message.length > 500) {
        showNotification('error', 'Message too long (max 500 characters)');
        return;
    }
    
    console.log('Sending chat message:', message);
    const resource = GetParentResourceName();
    fetch(`https://${resource}/sendChatMessage`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            message: message
        })
    }).then((response) => {
        return response.text();
    }).then((result) => {
        console.log('Chat message sent, clearing input');
        chatInput.value = '';
    }).catch(err => {
        console.error('Failed to send chat message:', err);
        showNotification('error', 'Failed to send message. Please try again.');
    });
}

function refreshChat() {
    const resource = GetParentResourceName();
    fetch(`https://${resource}/getChatMessages`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then((response) => {
        return response.text();
    }).then((result) => {
        // Chat messages are received via event
    }).catch(err => {
        console.error('Failed to refresh chat:', err);
    });
}

function displayChatMessage(messageData) {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) {
        console.error('Chat messages container not found - lounge tab may not be active');
        // Try to switch to lounge tab if message arrives
        if (currentTab !== 'lounge') {
            console.log('Switching to lounge tab to display message');
            switchTab('lounge');
            // Try again after a short delay
            setTimeout(() => {
                const retryContainer = document.getElementById('chatMessages');
                if (retryContainer && messageData) {
                    displayChatMessage(messageData);
                }
            }, 200);
        }
        return;
    }
    
    if (!messageData) {
        console.error('No message data provided');
        return;
    }
    
    // Remove empty state if present
    const emptyState = chatMessages.querySelector('.empty-state');
    if (emptyState) {
        emptyState.remove();
    }
    
    const messageDiv = document.createElement('div');
    messageDiv.className = 'chat-message';
    
    // Format timestamp - handle both date string and timestamp format
    let timeDisplay = 'Just now';
    if (messageData.timestamp) {
        try {
            // Try to parse the timestamp (format: '2024-01-15 14:30:00')
            const dateStr = messageData.timestamp.replace(' ', 'T');
            const date = new Date(dateStr);
            if (!isNaN(date.getTime())) {
                timeDisplay = date.toLocaleTimeString('en-US', {
                    hour: '2-digit',
                    minute: '2-digit'
                });
            } else {
                timeDisplay = messageData.timestamp;
            }
        } catch (e) {
            timeDisplay = messageData.timestamp;
        }
    }
    
    messageDiv.innerHTML = `
        <div class="chat-message-header">
            <span class="chat-author">${escapeHtml(messageData.authorName || 'Unknown')}</span>
            <span class="chat-time">${timeDisplay}</span>
        </div>
        <div class="chat-message-content">${escapeHtml(messageData.message || '')}</div>
    `;
    
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function displayChatMessages(messages) {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) {
        console.error('Chat messages container not found in displayChatMessages');
        return;
    }
    
    console.log('Displaying chat messages:', messages);
    chatMessages.innerHTML = '';
    
    if (messages && messages.length > 0) {
        messages.forEach(msg => {
            displayChatMessage(msg);
        });
        // Scroll to bottom after loading all messages
        setTimeout(() => {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }, 100);
    } else {
        chatMessages.innerHTML = `
            <div class="empty-state">
                <div class="empty-icon">💬</div>
                <h3>No messages yet</h3>
                <p>Start the conversation!</p>
            </div>
        `;
    }
}

// Resources Functions
function refreshResources() {
    const resource = GetParentResourceName();
    fetch(`https://${resource}/getResourcesList`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then((response) => {
        return response.text();
    }).catch(err => {
        console.error('Failed to refresh resources:', err);
    });
}

function displayResources(resources) {
    const resourcesList = document.getElementById('resourcesList');
    if (!resourcesList) {
        console.error('Resources list container not found');
        return;
    }
    
    resourcesList.innerHTML = '';
    
    if (resources && resources.length > 0) {
        resources.forEach(resource => {
            const resourceDiv = document.createElement('div');
            resourceDiv.className = 'task-item resource-item';
            resourceDiv.style.cursor = 'pointer';
            resourceDiv.onclick = () => viewResourceFiles(resource.name);
            
            let stateBadge = '';
            if (resource.state === 'started') {
                stateBadge = '<span class="task-status" style="background: #28a745; color: #fff;">Started</span>';
            } else if (resource.state === 'stopped') {
                stateBadge = '<span class="task-status" style="background: #dc3545; color: #fff;">Stopped</span>';
            } else if (resource.state === 'starting') {
                stateBadge = '<span class="task-status" style="background: #ffc107; color: #000;">Starting</span>';
            } else {
                stateBadge = '<span class="task-status" style="background: #6c757d; color: #fff;">' + (resource.state || 'Unknown') + '</span>';
            }
            
            resourceDiv.innerHTML = `
                <div class="task-header">
                    <span class="task-id">📦 ${escapeHtml(resource.name)}</span>
                    <div class="task-badges">
                        ${stateBadge}
                    </div>
                </div>
            `;
            
            resourcesList.appendChild(resourceDiv);
        });
    } else {
        resourcesList.innerHTML = `
            <div class="empty-state" id="resourcesEmpty">
                <div class="empty-icon">📦</div>
                <h3>No resources found</h3>
                <p>No server resources available.</p>
            </div>
        `;
    }
}

// View resource files
function viewResourceFiles(resourceName) {
    const resource = GetParentResourceName();
    fetch(`https://${resource}/getResourceFiles`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            resourceName: resourceName
        })
    }).then((response) => {
        return response.text();
    }).catch(err => {
        console.error('Failed to get resource files:', err);
        showNotification('error', 'Failed to load resource files');
    });
}

// Display resource files
function displayResourceFiles(resourceName, files) {
    const modal = document.getElementById('resourceFilesModal');
    const title = document.getElementById('resourceFilesTitle');
    const filesList = document.getElementById('resourceFilesList');
    
    if (!modal || !title || !filesList) {
        console.error('Resource files modal elements not found');
        return;
    }
    
    title.textContent = `Files in ${resourceName}`;
    filesList.innerHTML = '';
    
    if (files && files.length > 0) {
        files.forEach(file => {
            const fileDiv = document.createElement('div');
            fileDiv.className = 'task-item';
            fileDiv.style.padding = '12px';
            fileDiv.style.marginBottom = '8px';
            
            const lastModified = file.lastModified ? formatDate(file.lastModified) : 'Unknown';
            
            fileDiv.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: 500; margin-bottom: 4px;">${escapeHtml(file.path)}</div>
                        <div style="font-size: 12px; color: var(--text-secondary);">
                            <span>🕒</span> Last Modified: ${lastModified}
                        </div>
                    </div>
                </div>
            `;
            
            filesList.appendChild(fileDiv);
        });
    } else {
        filesList.innerHTML = `
            <div class="empty-state">
                <div class="empty-icon">📁</div>
                <h3>No files found</h3>
                <p>This resource has no files.</p>
            </div>
        `;
    }
    
    modal.classList.remove('hidden');
}

// Close resource files modal
function closeResourceFilesModal() {
    const modal = document.getElementById('resourceFilesModal');
    if (modal) {
        modal.classList.add('hidden');
    }
}

// Display resource tasks (when resource is selected in task creation)
function displayResourceTasks(resourceName, tasks) {
    const resourceTasksInfo = document.getElementById('resourceTasksInfo');
    if (!resourceTasksInfo) {
        return;
    }
    
    resourceTasksInfo.classList.remove('hidden');
    
    if (tasks && tasks.length > 0) {
        let html = `<div style="margin-top: 16px; padding: 12px; background: var(--bg-secondary); border-radius: 6px;">`;
        html += `<strong>Existing tasks for ${escapeHtml(resourceName)}:</strong><br>`;
        tasks.forEach(task => {
            const priority = task.priority || 'normal';
            const priorityLabels = { 'low': 'Low', 'normal': 'Normal', 'high': 'High', 'urgent': 'Urgent', 'started': 'Started' };
            html += `<div style="margin-top: 8px; padding: 8px; background: var(--bg-primary); border-radius: 4px;">`;
            html += `<span style="font-weight: 500;">#${task.id}</span> `;
            if (task.title) {
                html += `<span>${escapeHtml(task.title)}</span> - `;
            }
            html += `<span class="task-priority priority-${priority}" style="margin: 0 4px;">${priorityLabels[priority] || 'Normal'}</span>`;
            html += `<span class="task-status ${task.status}" style="margin-left: 4px;">${task.status}</span>`;
            html += `</div>`;
        });
        html += `</div>`;
        resourceTasksInfo.innerHTML = html;
    } else {
        resourceTasksInfo.innerHTML = `<div style="margin-top: 16px; padding: 12px; background: var(--bg-secondary); border-radius: 6px; color: var(--text-secondary);">No existing tasks for ${escapeHtml(resourceName)}</div>`;
    }
}

// Copy position to clipboard
function copyPosition(x, y, z, heading) {
    const coords = `vector4(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}, ${heading.toFixed(2)})`;
    const coordsSimple = `${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}, ${heading.toFixed(2)}`;
    
    // Try to copy to clipboard
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(coords).then(() => {
            showNotification('success', 'Coordinates copied to clipboard!');
        }).catch(() => {
            // Fallback: select text
            fallbackCopy(coords);
        });
    } else {
        // Fallback: select text
        fallbackCopy(coords);
    }
}

// Fallback copy method
function fallbackCopy(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.opacity = '0';
    document.body.appendChild(textArea);
    textArea.select();
    try {
        document.execCommand('copy');
        showNotification('success', 'Coordinates copied to clipboard!');
    } catch (err) {
        showNotification('error', 'Failed to copy. Coordinates: ' + text);
    }
    document.body.removeChild(textArea);
}

// Teleport to position
function teleportToPosition(x, y, z, heading) {
    const resource = GetParentResourceName();
    fetch(`https://${resource}/teleportToPosition`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            x: x,
            y: y,
            z: z,
            heading: heading
        })
    }).then((response) => {
        return response.text();
    }).then((result) => {
        showNotification('success', 'Teleporting to location...');
        closeTaskDetailsModal();
    }).catch(err => {
        console.error('Failed to teleport:', err);
        showNotification('error', 'Failed to teleport. You may not have permission.');
    });
}

// ==================== SETTINGS MANAGEMENT ====================

// Flag to prevent event loops when programmatically updating settings
let isUpdatingSettings = false;

// Default settings
const defaultSettings = {
    accentColor: '#f44336',
    accentHover: '#d32f2f',
    successColor: '#4caf50',
    dangerColor: '#f44336',
    warningColor: '#ff9800',
    infoColor: '#2196f3',
    bgPrimary: '#1a1d29',
    bgSecondary: '#252936',
    bgTertiary: '#2d3142',
    sidebarBg: '#141722',
    textPrimary: '#ffffff',
    textSecondary: '#b0b0b0',
    borderColor: '#3d4050',
    btnPrimary: '#f44336',
    btnPrimaryHover: '#d32f2f',
    btnSecondary: '#6c757d',
    btnSecondaryHover: '#5a6268',
    borderRadius: 8,
    cardShadow: 12
};

// Load settings from localStorage
function loadSettings() {
    try {
        const saved = localStorage.getItem('clearpath_settings');
        if (saved) {
            const settings = JSON.parse(saved);
            applySettings(settings);
            populateSettingsForm(settings);
        } else {
            applySettings(defaultSettings);
            populateSettingsForm(defaultSettings);
        }
    } catch (err) {
        console.error('Error loading settings:', err);
        applySettings(defaultSettings);
        populateSettingsForm(defaultSettings);
    }
}

// Save settings to localStorage
function saveSettings() {
    try {
        const settings = {
            accentColor: document.getElementById('accentColor').value,
            accentHover: document.getElementById('accentHoverColor').value,
            successColor: document.getElementById('successColor').value,
            dangerColor: document.getElementById('dangerColor').value,
            warningColor: document.getElementById('warningColor').value,
            infoColor: document.getElementById('infoColor').value,
            bgPrimary: document.getElementById('bgPrimaryColor').value,
            bgSecondary: document.getElementById('bgSecondaryColor').value,
            bgTertiary: document.getElementById('bgTertiaryColor').value,
            sidebarBg: document.getElementById('sidebarBgColor').value,
            textPrimary: document.getElementById('textPrimaryColor').value,
            textSecondary: document.getElementById('textSecondaryColor').value,
            borderColor: document.getElementById('borderColor').value,
            btnPrimary: document.getElementById('btnPrimaryColor').value,
            btnPrimaryHover: document.getElementById('btnPrimaryHoverColor').value,
            btnSecondary: document.getElementById('btnSecondaryColor').value,
            btnSecondaryHover: document.getElementById('btnSecondaryHoverColor').value,
            borderRadius: parseInt(document.getElementById('borderRadius').value),
            cardShadow: parseInt(document.getElementById('cardShadow').value)
        };
        
        localStorage.setItem('clearpath_settings', JSON.stringify(settings));
        applySettings(settings);
        
        // Show success message
        const saveBtn = document.getElementById('saveSettingsBtn');
        const originalText = saveBtn.textContent;
        saveBtn.textContent = 'Saved!';
        saveBtn.style.background = 'var(--success-color)';
        setTimeout(() => {
            saveBtn.textContent = originalText;
            saveBtn.style.background = '';
        }, 2000);
    } catch (err) {
        console.error('Error saving settings:', err);
    }
}

// Apply settings to CSS variables
function applySettings(settings) {
    try {
        const root = document.documentElement;
        
        // Ensure settings object has all required properties with defaults
        const safeSettings = {
            accentColor: settings.accentColor || defaultSettings.accentColor,
            accentHover: settings.accentHover || defaultSettings.accentHover,
            successColor: settings.successColor || defaultSettings.successColor,
            dangerColor: settings.dangerColor || defaultSettings.dangerColor,
            warningColor: settings.warningColor || defaultSettings.warningColor,
            infoColor: settings.infoColor || defaultSettings.infoColor,
            bgPrimary: settings.bgPrimary || defaultSettings.bgPrimary,
            bgSecondary: settings.bgSecondary || defaultSettings.bgSecondary,
            bgTertiary: settings.bgTertiary || defaultSettings.bgTertiary,
            sidebarBg: settings.sidebarBg || defaultSettings.sidebarBg,
            textPrimary: settings.textPrimary || defaultSettings.textPrimary,
            textSecondary: settings.textSecondary || defaultSettings.textSecondary,
            borderColor: settings.borderColor || defaultSettings.borderColor,
            btnPrimary: settings.btnPrimary || defaultSettings.btnPrimary,
            btnPrimaryHover: settings.btnPrimaryHover || defaultSettings.btnPrimaryHover,
            btnSecondary: settings.btnSecondary || defaultSettings.btnSecondary,
            btnSecondaryHover: settings.btnSecondaryHover || defaultSettings.btnSecondaryHover,
            borderRadius: settings.borderRadius !== undefined ? settings.borderRadius : defaultSettings.borderRadius,
            cardShadow: settings.cardShadow !== undefined ? settings.cardShadow : defaultSettings.cardShadow
        };
        
        // Convert hex to RGB for rgba usage
        function hexToRgb(hex) {
            if (!hex) return null;
            const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16),
                g: parseInt(result[2], 16),
                b: parseInt(result[3], 16)
            } : null;
        }
        
        // Apply action colors
        root.style.setProperty('--accent-color', safeSettings.accentColor);
        root.style.setProperty('--accent-hover', safeSettings.accentHover);
        root.style.setProperty('--success-color', safeSettings.successColor);
        root.style.setProperty('--danger-color', safeSettings.dangerColor);
        root.style.setProperty('--warning-color', safeSettings.warningColor);
        root.style.setProperty('--info-color', safeSettings.infoColor);
        
        // Apply background colors
        root.style.setProperty('--bg-primary', safeSettings.bgPrimary);
        root.style.setProperty('--bg-secondary', safeSettings.bgSecondary);
        root.style.setProperty('--bg-tertiary', safeSettings.bgTertiary);
        root.style.setProperty('--sidebar-bg', safeSettings.sidebarBg);
        
        // Apply text colors
        root.style.setProperty('--text-primary', safeSettings.textPrimary);
        root.style.setProperty('--text-secondary', safeSettings.textSecondary);
        
        // Apply border color
        root.style.setProperty('--border-color', safeSettings.borderColor);
        
        // Apply button colors
        root.style.setProperty('--btn-primary', safeSettings.btnPrimary);
        root.style.setProperty('--btn-primary-hover', safeSettings.btnPrimaryHover);
        root.style.setProperty('--btn-secondary', safeSettings.btnSecondary);
        root.style.setProperty('--btn-secondary-hover', safeSettings.btnSecondaryHover);
        
        // Apply UI elements
        root.style.setProperty('--border-radius-base', safeSettings.borderRadius + 'px');
        root.style.setProperty('--card-shadow-blur', safeSettings.cardShadow + 'px');
        
        // Update slider thumb colors
        const accentRgb = hexToRgb(safeSettings.accentColor);
        if (accentRgb) {
            root.style.setProperty('--accent-color-rgb', `${accentRgb.r}, ${accentRgb.g}, ${accentRgb.b}`);
        }
    } catch (err) {
        console.error('Error applying settings:', err);
        // Fallback to defaults on error
        try {
            applySettings(defaultSettings);
        } catch (fallbackErr) {
            console.error('Critical error: Could not apply default settings', fallbackErr);
        }
    }
}

// Populate settings form with values
function populateSettingsForm(settings) {
    try {
        // Set flag to prevent event loops
        isUpdatingSettings = true;
        
        // Ensure settings object has all required properties
        const safeSettings = {
            accentColor: settings.accentColor || defaultSettings.accentColor,
            accentHover: settings.accentHover || defaultSettings.accentHover,
            successColor: settings.successColor || defaultSettings.successColor,
            dangerColor: settings.dangerColor || defaultSettings.dangerColor,
            warningColor: settings.warningColor || defaultSettings.warningColor,
            infoColor: settings.infoColor || defaultSettings.infoColor,
            bgPrimary: settings.bgPrimary || defaultSettings.bgPrimary,
            bgSecondary: settings.bgSecondary || defaultSettings.bgSecondary,
            bgTertiary: settings.bgTertiary || defaultSettings.bgTertiary,
            sidebarBg: settings.sidebarBg || defaultSettings.sidebarBg,
            textPrimary: settings.textPrimary || defaultSettings.textPrimary,
            textSecondary: settings.textSecondary || defaultSettings.textSecondary,
            borderColor: settings.borderColor || defaultSettings.borderColor,
            btnPrimary: settings.btnPrimary || defaultSettings.btnPrimary,
            btnPrimaryHover: settings.btnPrimaryHover || defaultSettings.btnPrimaryHover,
            btnSecondary: settings.btnSecondary || defaultSettings.btnSecondary,
            btnSecondaryHover: settings.btnSecondaryHover || defaultSettings.btnSecondaryHover,
            borderRadius: settings.borderRadius !== undefined ? settings.borderRadius : defaultSettings.borderRadius,
            cardShadow: settings.cardShadow !== undefined ? settings.cardShadow : defaultSettings.cardShadow
        };
        
        // Helper function to set color input and text
        function setColorInput(id, value) {
            const picker = document.getElementById(id);
            const text = document.getElementById(id + 'Text');
            if (picker) picker.value = value;
            if (text) text.value = value;
        }
        
        // Action colors
        setColorInput('accentColor', safeSettings.accentColor);
        setColorInput('accentHoverColor', safeSettings.accentHover);
        setColorInput('successColor', safeSettings.successColor);
        setColorInput('dangerColor', safeSettings.dangerColor);
        setColorInput('warningColor', safeSettings.warningColor);
        setColorInput('infoColor', safeSettings.infoColor);
        
        // Background colors
        setColorInput('bgPrimaryColor', safeSettings.bgPrimary);
        setColorInput('bgSecondaryColor', safeSettings.bgSecondary);
        setColorInput('bgTertiaryColor', safeSettings.bgTertiary);
        setColorInput('sidebarBgColor', safeSettings.sidebarBg);
        
        // Text colors
        setColorInput('textPrimaryColor', safeSettings.textPrimary);
        setColorInput('textSecondaryColor', safeSettings.textSecondary);
        
        // Border color
        setColorInput('borderColor', safeSettings.borderColor);
        
        // Button colors
        setColorInput('btnPrimaryColor', safeSettings.btnPrimary);
        setColorInput('btnPrimaryHoverColor', safeSettings.btnPrimaryHover);
        setColorInput('btnSecondaryColor', safeSettings.btnSecondary);
        setColorInput('btnSecondaryHoverColor', safeSettings.btnSecondaryHover);
        
        // Sliders
        const borderRadiusEl = document.getElementById('borderRadius');
        if (borderRadiusEl) {
            borderRadiusEl.value = safeSettings.borderRadius;
            const valueEl = document.getElementById('borderRadiusValue');
            if (valueEl) valueEl.textContent = safeSettings.borderRadius + 'px';
        }
        const cardShadowEl = document.getElementById('cardShadow');
        if (cardShadowEl) {
            cardShadowEl.value = safeSettings.cardShadow;
            const valueEl = document.getElementById('cardShadowValue');
            if (valueEl) valueEl.textContent = safeSettings.cardShadow + 'px';
        }
        
        // Reset flag after a short delay to ensure all updates are complete
        setTimeout(() => {
            isUpdatingSettings = false;
        }, 100);
    } catch (err) {
        console.error('Error populating settings form:', err);
        isUpdatingSettings = false; // Always reset flag on error
    }
}

// Reset settings to default
function resetSettings() {
    // Use in-game modal instead of browser confirm() to prevent external windows
    showConfirm(
        'Reset Settings',
        'Are you sure you want to reset all settings to default values? This cannot be undone.',
        function() {
            try {
                // Set flag to prevent event loops
                isUpdatingSettings = true;
                
                // Remove saved settings
                localStorage.removeItem('clearpath_settings');
                
                // Apply default settings (without triggering form updates)
                applySettings(defaultSettings);
                
                // Populate form with defaults (only if settings container is visible)
                const settingsContainer = document.getElementById('settingsContainer');
                if (settingsContainer && !settingsContainer.classList.contains('hidden')) {
                    populateSettingsForm(defaultSettings);
                } else {
                    // Reset flag if container is not visible
                    isUpdatingSettings = false;
                }
                
                // Show success message
                showNotification('success', 'Settings reset to default values');
            } catch (err) {
                console.error('Error resetting settings:', err);
                isUpdatingSettings = false; // Always reset flag on error
                showNotification('error', 'Failed to reset settings. Please refresh the page.');
            }
        }
    );
}

// Setup settings event listeners
function setupSettingsListeners() {
    // Color pickers sync with text inputs
    const colorPairs = [
        ['accentColor', 'accentColorText'],
        ['accentHoverColor', 'accentHoverColorText'],
        ['successColor', 'successColorText'],
        ['dangerColor', 'dangerColorText'],
        ['warningColor', 'warningColorText'],
        ['infoColor', 'infoColorText'],
        ['bgPrimaryColor', 'bgPrimaryColorText'],
        ['bgSecondaryColor', 'bgSecondaryColorText'],
        ['bgTertiaryColor', 'bgTertiaryColorText'],
        ['sidebarBgColor', 'sidebarBgColorText'],
        ['textPrimaryColor', 'textPrimaryColorText'],
        ['textSecondaryColor', 'textSecondaryColorText'],
        ['borderColor', 'borderColorText'],
        ['btnPrimaryColor', 'btnPrimaryColorText'],
        ['btnPrimaryHoverColor', 'btnPrimaryHoverColorText'],
        ['btnSecondaryColor', 'btnSecondaryColorText'],
        ['btnSecondaryHoverColor', 'btnSecondaryHoverColorText']
    ];
    
    colorPairs.forEach(([pickerId, textId]) => {
        const picker = document.getElementById(pickerId);
        const text = document.getElementById(textId);
        
        if (picker && text) {
            // Picker -> Text
            picker.addEventListener('input', function() {
                if (isUpdatingSettings) return; // Prevent loops
                text.value = this.value;
                applySettings(getCurrentSettings());
            });
            
            // Text -> Picker (with validation)
            text.addEventListener('input', function() {
                if (isUpdatingSettings) return; // Prevent loops
                const hex = this.value.trim();
                if (/^#[0-9A-F]{6}$/i.test(hex)) {
                    picker.value = hex;
                    applySettings(getCurrentSettings());
                }
            });
        }
    });
    
    // Sliders
    const borderRadiusSlider = document.getElementById('borderRadius');
    const borderRadiusValue = document.getElementById('borderRadiusValue');
    if (borderRadiusSlider && borderRadiusValue) {
        borderRadiusSlider.addEventListener('input', function() {
            if (isUpdatingSettings) return; // Prevent loops
            borderRadiusValue.textContent = this.value + 'px';
            applySettings(getCurrentSettings());
        });
    }
    
    const cardShadowSlider = document.getElementById('cardShadow');
    const cardShadowValue = document.getElementById('cardShadowValue');
    if (cardShadowSlider && cardShadowValue) {
        cardShadowSlider.addEventListener('input', function() {
            if (isUpdatingSettings) return; // Prevent loops
            cardShadowValue.textContent = this.value + 'px';
            applySettings(getCurrentSettings());
        });
    }
    
    // Save and Reset buttons
    const saveBtn = document.getElementById('saveSettingsBtn');
    const resetBtn = document.getElementById('resetSettingsBtn');
    
    if (saveBtn) {
        saveBtn.addEventListener('click', saveSettings);
    }
    
    if (resetBtn) {
        resetBtn.addEventListener('click', resetSettings);
    }
}

// Get current settings from form
function getCurrentSettings() {
    return {
        accentColor: document.getElementById('accentColor')?.value || defaultSettings.accentColor,
        accentHover: document.getElementById('accentHoverColor')?.value || defaultSettings.accentHover,
        successColor: document.getElementById('successColor')?.value || defaultSettings.successColor,
        dangerColor: document.getElementById('dangerColor')?.value || defaultSettings.dangerColor,
        warningColor: document.getElementById('warningColor')?.value || defaultSettings.warningColor,
        infoColor: document.getElementById('infoColor')?.value || defaultSettings.infoColor,
        bgPrimary: document.getElementById('bgPrimaryColor')?.value || defaultSettings.bgPrimary,
        bgSecondary: document.getElementById('bgSecondaryColor')?.value || defaultSettings.bgSecondary,
        bgTertiary: document.getElementById('bgTertiaryColor')?.value || defaultSettings.bgTertiary,
        sidebarBg: document.getElementById('sidebarBgColor')?.value || defaultSettings.sidebarBg,
        textPrimary: document.getElementById('textPrimaryColor')?.value || defaultSettings.textPrimary,
        textSecondary: document.getElementById('textSecondaryColor')?.value || defaultSettings.textSecondary,
        borderColor: document.getElementById('borderColor')?.value || defaultSettings.borderColor,
        btnPrimary: document.getElementById('btnPrimaryColor')?.value || defaultSettings.btnPrimary,
        btnPrimaryHover: document.getElementById('btnPrimaryHoverColor')?.value || defaultSettings.btnPrimaryHover,
        btnSecondary: document.getElementById('btnSecondaryColor')?.value || defaultSettings.btnSecondary,
        btnSecondaryHover: document.getElementById('btnSecondaryHoverColor')?.value || defaultSettings.btnSecondaryHover,
        borderRadius: parseInt(document.getElementById('borderRadius')?.value || defaultSettings.borderRadius),
        cardShadow: parseInt(document.getElementById('cardShadow')?.value || defaultSettings.cardShadow)
    };
}
