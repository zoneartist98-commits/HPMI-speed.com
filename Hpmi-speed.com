<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HPMI - Advanced AI Assistant</title>
    <style>
        /* ====================================================================
           ROOT VARIABLES
           ==================================================================== */
        :root {
            --primary: #7C3AED;
            --primary-light: #A78BFA;
            --primary-dark: #6D28D9;
            --bg: #f5f3ff;
            --card: #ffffff;
            --text: #1F2937;
            --text-light: #6B7280;
            --border: #E5E7EB;
            --shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            --radius: 16px;
            --transition: 0.3s ease;
        }

        [data-theme="dark"] {
            --bg: #111827;
            --card: #1F2937;
            --text: #F9FAFB;
            --text-light: #9CA3AF;
            --border: #374151;
            --shadow: 0 4px 6px -1px rgba(0,0,0,0.3);
        }

        /* ====================================================================
           RESET & BASE
           ==================================================================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            transition: background var(--transition), color var(--transition), border var(--transition);
        }

        body {
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 16px;
        }

        /* ====================================================================
           APP CONTAINER
           ==================================================================== */
        .app {
            width: 100%;
            max-width: 420px;
            height: 820px;
            background: var(--card);
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        /* ====================================================================
           PAGES
           ==================================================================== */
        .page {
            display: none;
            flex-direction: column;
            height: 100%;
            padding: 20px;
            overflow-y: auto;
            background: var(--bg);
        }

        .page.active {
            display: flex;
        }

        /* ====================================================================
           LOGIN PAGE
           ==================================================================== */
        .login-page {
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .logo {
            font-size: 52px;
            margin-bottom: 8px;
        }

        .app-title {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .welcome {
            font-size: 16px;
            margin: 8px 0 24px;
            color: var(--text);
        }

        .input-group {
            width: 100%;
            margin-bottom: 14px;
            text-align: left;
        }

        .input-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 4px;
            color: var(--text);
        }

        .input-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 15px;
            background: var(--bg);
            color: var(--text);
            outline: none;
        }

        .input-group input:focus {
            border-color: var(--primary);
        }

        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: scale(1.02);
        }

        .btn-secondary {
            width: 100%;
            padding: 14px;
            background: var(--card);
            color: var(--text);
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-secondary:hover {
            background: var(--bg);
        }

        .link {
            color: var(--primary);
            cursor: pointer;
            font-weight: 500;
            background: none;
            border: none;
            font-size: 14px;
        }

        .link:hover {
            text-decoration: underline;
        }

        .theme-toggle {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow);
        }

        /* ====================================================================
           PRIVACY PAGE
           ==================================================================== */
        .privacy-text {
            background: var(--card);
            padding: 16px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
            font-size: 14px;
            line-height: 1.8;
            margin: 16px 0;
            max-height: 300px;
            overflow-y: auto;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 12px 0;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
        }

        /* ====================================================================
           MAIN CHAT
           ==================================================================== */
        .top-bar {
            background: var(--card);
            padding: 12px 16px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
            box-shadow: var(--shadow);
        }

        .top-bar .left {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .top-bar .badge {
            background: var(--primary);
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 600;
            cursor: pointer;
        }

        .top-bar .title {
            font-size: 16px;
            font-weight: 700;
            color: var(--primary);
        }

        .top-bar .avatar {
            font-size: 22px;
            cursor: pointer;
            background: none;
            border: none;
        }

        /* Chat Display */
        .chat-display {
            flex: 1;
            background: var(--card);
            border-radius: var(--radius);
            padding: 16px;
            overflow-y: auto;
            margin-bottom: 10px;
            border: 1px solid var(--border);
            min-height: 300px;
        }

        .chat-display .message {
            margin-bottom: 12px;
            animation: fadeIn 0.3s ease;
        }

        .chat-display .message.user {
            text-align: right;
        }

        .chat-display .message .sender {
            font-weight: 600;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 2px;
        }

        .chat-display .message.user .sender {
            color: var(--primary);
        }

        .chat-display .message .content {
            display: inline-block;
            padding: 10px 14px;
            border-radius: var(--radius);
            max-width: 85%;
            word-wrap: break-word;
            font-size: 14px;
            line-height: 1.5;
        }

        .chat-display .message.user .content {
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 4px;
        }

        .chat-display .message.ai .content {
            background: var(--bg);
            color: var(--text);
            border-bottom-left-radius: 4px;
        }

        .chat-display .typing {
            color: var(--primary-light);
            font-style: italic;
            font-size: 13px;
            padding: 8px 0;
        }

        .chat-display .status {
            color: var(--text-light);
            font-size: 11px;
            padding: 4px 0;
            text-align: center;
        }

        .chat-display .tool-message {
            color: var(--primary);
            font-weight: 600;
            font-size: 13px;
            padding: 6px 0;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Tools */
        .tools {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 4px;
            margin-bottom: 8px;
        }

        .tools button {
            padding: 8px 4px;
            background: var(--primary-light);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .tools button:hover {
            transform: scale(1.05);
        }

        /* Input */
        .input-area {
            display: flex;
            gap: 8px;
            background: var(--card);
            padding: 8px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
        }

        .input-area input {
            flex: 1;
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            background: var(--bg);
            color: var(--text);
            font-size: 14px;
            outline: none;
        }

        .input-area .send-btn {
            padding: 10px 16px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .input-area .send-btn:hover {
            transform: scale(1.05);
        }

        /* Navigation */
        .nav-bar {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 4px;
            background: var(--card);
            padding: 6px;
            border-radius: var(--radius);
            margin-top: 8px;
            box-shadow: var(--shadow);
        }

        .nav-bar button {
            padding: 8px;
            background: transparent;
            border: none;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 600;
            color: var(--text);
            cursor: pointer;
            transition: background 0.3s;
        }

        .nav-bar button:hover {
            background: var(--bg);
        }

        .nav-bar button.active {
            background: var(--primary);
            color: white;
        }

        /* ====================================================================
           OVERVIEW
           ==================================================================== */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .page-header h2 {
            font-size: 20px;
            color: var(--primary);
        }

        .news-container {
            flex: 1;
            background: var(--card);
            border-radius: var(--radius);
            padding: 16px;
            border: 1px solid var(--border);
            overflow-y: auto;
        }

        .news-container .news-item {
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
        }

        .news-container .news-item:last-child {
            border-bottom: none;
        }

        .news-container .news-item .title {
            font-weight: 600;
            font-size: 14px;
        }

        .news-container .news-item .time {
            font-size: 11px;
            color: var(--text-light);
            margin-top: 2px;
        }

        /* ====================================================================
           RESEARCH
           ==================================================================== */
        .topic-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .topic-list button {
            padding: 14px 16px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            font-size: 14px;
            font-weight: 500;
            color: var(--text);
            cursor: pointer;
            text-align: left;
            transition: all 0.3s;
        }

        .topic-list button:hover {
            border-color: var(--primary);
            background: var(--bg);
        }

        /* ====================================================================
           PROFILE
           ==================================================================== */
        .profile-avatar {
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-avatar .avatar-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--primary-light);
            color: white;
            font-size: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
        }

        .profile-avatar .edit-photo {
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 13px;
        }

        .profile-field {
            margin-bottom: 12px;
        }

        .profile-field label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 2px;
        }

        .profile-field input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: var(--bg);
            color: var(--text);
            font-size: 14px;
            outline: none;
        }

        .profile-field input:focus {
            border-color: var(--primary);
        }

        .profile-settings {
            margin: 16px 0;
            padding: 12px;
            background: var(--card);
            border-radius: var(--radius);
            border: 1px solid var(--border);
        }

        .profile-settings .setting {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            font-size: 13px;
        }

        .profile-settings .setting .label {
            color: var(--text-light);
        }

        .profile-actions {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-top: 12px;
        }

        .profile-actions button {
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .profile-actions button:hover {
            opacity: 0.9;
        }

        .btn-danger {
            background: #EF4444;
            color: white;
        }

        .btn-warning {
            background: #DC2626;
            color: white;
        }

        .btn-gray {
            background: #6B7280;
            color: white;
        }

        /* ====================================================================
           SCROLLBAR
           ==================================================================== */
        ::-webkit-scrollbar {
            width: 4px;
        }

        ::-webkit-scrollbar-track {
            background: transparent;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--primary-light);
            border-radius: 10px;
        }

        /* ====================================================================
           RESPONSIVE
           ==================================================================== */
        @media (max-width: 480px) {
            .app {
                height: 100vh;
                border-radius: 0;
                max-width: 100%;
            }
            body {
                padding: 0;
            }
        }
    </style>
</head>
<body>

<!-- ========================================================================
     APP
     ======================================================================== -->
<div class="app" id="app">

    <!-- ====================================================================
         PAGE 1: LOGIN
         ==================================================================== -->
    <div class="page login-page active" id="loginPage">
        <div class="logo">⚡</div>
        <div class="app-title">HPMI</div>
        <div class="welcome">Welcome back 👏</div>

        <div class="input-group">
            <label>Email</label>
            <input type="email" id="loginEmail" value="demo@hpmi.com">
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="loginPassword" value="password123">
        </div>

        <button class="btn-primary" onclick="login()">Login</button>
        <div style="margin: 10px 0; color: var(--text-light); font-size: 13px;">or</div>
        <button class="btn-secondary" onclick="googleLogin()">Continue with Google</button>

        <button class="link" style="margin-top: 16px;" onclick="showSignup()">Create account</button>

        <button class="theme-toggle" onclick="toggleTheme()" id="themeBtn">🌙</button>
    </div>

    <!-- ====================================================================
         PAGE 2: SIGNUP
         ==================================================================== -->
    -->
    <div class="page" id="signupPage">
        <div style="text-align: center; margin-bottom: 20px;">
            <div class="logo" style="font-size: 40px;">⚡</div>
            <div class="app-title" style="font-size: 22px;">Create Account</div>
        </div>

        <div class="input-group">
            <label>Full Name</label>
            <input type="text" id="signupName" placeholder="Your name">
        </div>
        <div class="input-group">
            <label>Email</label>
            <input type="email" id="signupEmail" placeholder="your@email.com">
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="signupPassword" placeholder="Create password">
        </div>

        <button class="btn-primary" onclick="signup()">Sign Up</button>
        <button class="link" style="margin-top: 12px;" onclick="showLogin()">← Back to Login</button>
    </div>

    <!-- ====================================================================
         PAGE 3: PRIVACY
         ==================================================================== -->
    <div class="page" id="privacyPage">
        <div style="text-align: center; margin-bottom: 16px;">
            <div class="logo" style="font-size: 40px;">⚡</div>
            <div class="app-title" style="font-size: 22px;">Privacy Policy</div>
        </div>

        <div class="privacy-text">
            <strong>By continuing you agree to:</strong><br>
            • Your data is encrypted 🔒<br>
            • Conversations are private 🤫<br>
            • Delete data anytime 🗑️<br>
            • Powered by HPMI neural engine 🧠<br><br>
            <span style="color: var(--text-light); font-size: 13px;">
                Version 2.0.0 • Last updated: June 2026
            </span>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="agreePrivacy" onchange="togglePrivacyContinue()">
            <label for="agreePrivacy" style="font-size: 14px;">I agree to the Privacy Policy</label>
        </div>

        <button class="btn-primary" id="privacyContinue" disabled onclick="showMain()">Continue</button>
    </div>

    <!-- ====================================================================
         PAGE 4: MAIN CHAT
         ==================================================================== -->
    <div class="page" id="mainPage">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="left">
                <span class="badge" onclick="checkUpdate()">⚡ UPDATE</span>
                <span class="title">HPMI</span>
            </div>
            <button class="avatar" onclick="showProfile()">👤</button>
        </div>

        <!-- Chat Display -->
        <div class="chat-display" id="chatDisplay">
            <div class="message ai">
                <div class="sender">HPMI</div>
                <div class="content">🤖 Welcome to HPMI!<br>Neural Engine Active ⚡</div>
            </div>
            <div class="status">⏺️ Ready</div>
        </div>

        <!-- Tools -->
        <div class="tools">
            <button onclick="generateImage()">🎨</button>
            <button onclick="toggleVoice()">🎤</button>
            <button onclick="searchWeb()">🔍</button>
            <button onclick="deepThink()">🧠</button>
            <button onclick="openGallery()">🖼️</button>
            <button onclick="openCamera()">📷</button>
        </div>

        <!-- Input -->
        <div class="input-area">
            <input type="text" id="chatInput" placeholder="Type a message..." onkeydown="if(event.key==='Enter') sendMessage()">
            <button class="send-btn" onclick="sendMessage()">⏺️</button>
        </div>

        <!-- Navigation -->
        <div class="nav-bar">
            <button class="active" onclick="showMain()">💬 CHAT</button>
            <button onclick="showOverview()">📊 OVERVIEW</button>
            <button onclick="showResearch()">🔬 RESEARCH</button>
            <button onclick="showProfile()">👤 PROFILE</button>
        </div>
    </div>

    <!-- ====================================================================
         PAGE 5: OVERVIEW
         ==================================================================== -->
    <div class="page" id="overviewPage">
        <div class="page-header">
            <h2>📊 OVERVIEW</h2>
            <button class="badge" onclick="refreshNews()" style="font-size: 12px;">🔄 Refresh</button>
        </div>
        <div class="news-container" id="newsContainer">
            <div class="news-item">
                <div class="title">🌍 Global AI Summit 2026 begins</div>
                <div class="time">Just now</div>
            </div>
            <div class="news-item">
                <div class="title">💰 Tech stocks reach new highs</div>
                <div class="time">5 min ago</div>
            </div>
            <div class="news-item">
                <div class="title">🚀 SpaceX launches satellite network</div>
                <div class="time">15 min ago</div>
            </div>
            <div class="news-item">
                <div class="title">🌡️ Climate change updates</div>
                <div class="time">30 min ago</div>
            </div>
            <div class="news-item">
                <div class="title">🎮 AI gaming breakthroughs</div>
                <div class="time">1 hour ago</div>
            </div>
        </div>
        <button class="btn-secondary" style="margin-top: 12px;" onclick="showMain()">← Back</button>
    </div>

    <!-- ====================================================================
         PAGE 6: RESEARCH
         ==================================================================== -->
    <div class="page" id="researchPage">
        <div class="page-header">
            <h2>🔬 RESEARCH</h2>
        </div>
        <div class="topic-list">
            <button onclick="searchTopic('AI Advancements')">📈 AI Advancements</button>
            <button onclick="searchTopic('FIFA World Cup')">📈 FIFA World Cup</button>
            <button onclick="searchTopic('Quantum Computing')">📈 Quantum Computing</button>
            <button onclick="searchTopic('Climate Tech')">📈 Climate Tech</button>
            <button onclick="searchTopic('Space Exploration')">📈 Space Exploration</button>
            <button onclick="searchTopic('Medical Innovations')">📈 Medical Innovations</button>
        </div>
        <button class="btn-secondary" style="margin-top: 12px;" onclick="showMain()">← Back</button>
    </div>

    <!-- ====================================================================
         PAGE 7: PROFILE
         ==================================================================== -->
    <div class="page" id="profilePage">
        <div class="profile-avatar">
            <div class="avatar-circle">👤</div>
            <button class="edit-photo" onclick="editPhoto()">📷 Edit Photo</button>
        </div>

        <div class="profile-field">
            <label>Name</label>
            <input type="text" id="profileName" value="HPMI User">
        </div>
        <div class="profile-field">
            <label>Bio</label>
            <input type="text" id="profileBio" value="AI Assistant User">
        </div>
        <div class="profile-field">
            <label>Discrimination</label>
            <input type="text" id="profileDisc" value="None">
        </div>

        <button class="btn-primary" onclick="updateProfile()" style="margin: 8px 0;">💾 Update Profile</button>

        <div class="profile-settings">
            <div class="setting">
                <span class="label">📡 Vision</span>
                <span>2.0.0</span>
            </div>
            <div class="setting">
                <span class="label">🌐 Language</span>
                <span>English</span>
            </div>
            <div class="setting">
                <span class="label">🎨 Theme</span>
                <button class="link" onclick="toggleTheme()" style="font-size: 13px;" id="themeToggleBtn">☀️ Light</button>
            </div>
        </div>

        <div class="profile-actions">
            <button class="btn-danger" onclick="clearChat()">🗑️ Clear Chat</button>
            <button class="btn-warning" onclick="clearData()">🗑️ Clear Data</button>
            <button class="btn-gray" onclick="logout()">🚪 Logout</button>
        </div>

        <button class="btn-secondary" style="margin-top: 12px;" onclick="showMain()">← Back</button>
    </div>

</div>

<!-- ========================================================================
     JAVASCRIPT
     ======================================================================== -->
<script>
// ============================================================================
// STATE
// ============================================================================

const state = {
    user: null,
    isDark: false,
    isProcessing: false,
    isVoice: false,
    messages: [],
    chatHistory: [],
    currentPage: 'loginPage'
};

// ============================================================================
// DOM HELPERS
// ============================================================================

function showPage(pageId) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    document.getElementById(pageId).classList.add('active');
    state.currentPage = pageId;
}

function addMessage(sender, content, type = 'ai') {
    const display = document.getElementById('chatDisplay');
    const div = document.createElement('div');
    div.className = `message ${type}`;
    div.innerHTML = `
        <div class="sender">${sender}</div>
        <div class="content">${content}</div>
    `;
    // Remove status if present
    const status = display.querySelector('.status');
    if (status) status.remove();
    display.appendChild(div);
    display.scrollTop = display.scrollHeight;
}

function addStatus(text) {
    const display = document.getElementById('chatDisplay');
    const status = document.createElement('div');
    status.className = 'status';
    status.textContent = text;
    display.appendChild(status);
    display.scrollTop = display.scrollHeight;
}

function addTyping() {
    const display = document.getElementById('chatDisplay');
    const typing = document.createElement('div');
    typing.className = 'typing';
    typing.id = 'typingIndicator';
    typing.textContent = '⏺️ HPMI is thinking...';
    display.appendChild(typing);
    display.scrollTop = display.scrollHeight;
}

function removeTyping() {
    const typing = document.getElementById('typingIndicator');
    if (typing) typing.remove();
}

function showNotification(title, message, icon = 'ℹ️') {
    alert(`${icon} ${title}\n\n${message}`);
}

// ============================================================================
// THEME
// ============================================================================

function toggleTheme() {
    state.isDark = !state.isDark;
    document.documentElement.setAttribute('data-theme', state.isDark ? 'dark' : 'light');
    document.getElementById('themeBtn').textContent = state.isDark ? '☀️' : '🌙';
    document.getElementById('themeToggleBtn').textContent = state.isDark ? '🌙 Dark' : '☀️ Light';
}

// ============================================================================
// LOGIN / SIGNUP
// ============================================================================

function showLogin() {
    showPage('loginPage');
}

function showSignup() {
    showPage('signupPage');
}

function login() {
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    if (email && password) {
        state.user = { email, name: 'HPMI User' };
        showPage('privacyPage');
    } else {
        alert('Please enter email and password');
    }
}

function googleLogin() {
    state.user = { email: 'google@gmail.com', name: 'Google User' };
    showPage('privacyPage');
}

function signup() {
    const name = document.getElementById('signupName').value;
    const email = document.getElementById('signupEmail').value;
    const password = document.getElementById('signupPassword').value;
    if (name && email && password) {
        alert('✅ Account created successfully!');
        showLogin();
    } else {
        alert('Please fill all fields');
    }
}

function togglePrivacyContinue() {
    const checked = document.getElementById('agreePrivacy').checked;
    document.getElementById('privacyContinue').disabled = !checked;
}

// ============================================================================
// CHAT
// ============================================================================

function sendMessage() {
    const input = document.getElementById('chatInput');
    const msg = input.value.trim();
    if (!msg || state.isProcessing) return;
    input.value = '';

    addMessage('You', msg, 'user');
    addTyping();
    state.isProcessing = true;

    // Simulate AI response
    setTimeout(() => {
        removeTyping();
        const responses = [
            `I'm HPMI, powered by neural engine. Regarding "${msg}", here's my analysis...`,
            `Great question! HPMI neural engine processing "${msg}" for optimal response.`,
            `Interesting! Let me think about "${msg}" and provide comprehensive insights.`,
            `HPMI here! Analyzing "${msg}" through my neural networks...`
        ];
        const resp = responses[Math.floor(Math.random() * responses.length)];
        addMessage('HPMI', resp);
        addStatus('⏺️ Ready');
        state.isProcessing = false;
    }, 1500 + Math.random() * 1000);
}

function showMain() {
    showPage('mainPage');
    document.querySelectorAll('.nav-bar button').forEach(b => b.classList.remove('active'));
    document.querySelector('.nav-bar button:first-child').classList.add('active');
}

// ============================================================================
// TOOLS
// ============================================================================

function generateImage() {
    const prompt = prompt('🎨 Describe the image you want to generate:');
    if (!prompt) return;
    addMessage('You', `🎨 Generate: ${prompt}`, 'user');
    addTyping();
    setTimeout(() => {
        removeTyping();
        addMessage('HPMI', `🎨 Image generated successfully!\nPrompt: "${prompt}"\n✨ Style: Photorealistic\n📐 Resolution: 512x512`);
        addStatus('⏺️ Ready');
    }, 2000);
}

function toggleVoice() {
    state.isVoice = !state.isVoice;
    addStatus(`🎤 Voice mode ${state.isVoice ? 'activated' : 'deactivated'}`);
    if (state.isVoice) {
        // Simulate voice recognition
        setTimeout(() => {
            addMessage('You', '🎤 Hello HPMI!', 'user');
            addTyping();
            setTimeout(() => {
                removeTyping();
                addMessage('HPMI', '🎤 Hello! I\'m HPMI, your voice assistant. How can I help?');
                addStatus('⏺️ Ready');
            }, 1000);
        }, 1000);
    }
}

function searchWeb() {
    const query = prompt('🔍 Enter search query:');
    if (!query) return;
    addMessage('You', `🔍 Search: ${query}`, 'user');
    addTyping();
    setTimeout(() => {
        removeTyping();
        addMessage('HPMI', `🔍 Search Results for "${query}":\n\n📌 Top results found on WePikia\n• ${query} - Wikipedia\n• ${query} - Latest News\n• ${query} - Research Papers\n\n🔗 Check browser for more results`);
        addStatus('⏺️ Ready');
        window.open(`https://www.google.com/search?q=${query}`, '_blank');
    }, 1500);
}

function deepThink() {
    const question = prompt('🧠 Enter question for deep analysis:');
    if (!question) return;
    addMessage('You', `🧠 Deep Think: ${question}`, 'user');
    addTyping();
    setTimeout(() => {
        removeTyping();
        const responses = [
            `🧠 DEEP THINK ANALYSIS\n\n📊 Perspectives:\n\n1. Analytical: ${question} involves complex systems...\n2. Creative: Innovation in ${question}...\n3. Practical: Real-world applications...\n\n✅ Best Response: ${question} requires multi-dimensional thinking...`
        ];
        addMessage('HPMI', responses[0]);
        addStatus('⏺️ Ready');
    }, 2500);
}

function openGallery() {
    // Simulate gallery picker
    addMessage('You', '🖼️ Selected image from gallery', 'user');
    addTyping();
    setTimeout(() => {
        removeTyping();
        addMessage('HPMI', '🖼️ Image Analysis:\n\n📁 Filename: photo_2026.jpg\n📐 Resolution: 1920x1080\n\n🔍 Visual Analysis:\n• Image contains natural scene\n• Colors: vibrant\n• Objects detected: sky, trees, building\n\n🧠 HPMI neural engine processed successfully!');
        addStatus('⏺️ Ready');
    }, 1800);
}

function openCamera() {
    // Simulate camera capture
    addMessage('You', '📷 Camera photo captured', 'user');
    addTyping();
    setTimeout(() => {
        removeTyping();
        addMessage('HPMI', '📷 Camera Analysis:\n\n✅ Photo captured successfully\n📐 Resolution: 1280x720\n📁 Saved: camera_2026.jpg\n\n🔍 Quick Analysis:\n• Well-lit image\n• Clear focus\n• Scene detected\n\n📸 HPMI vision ready!');
        addStatus('⏺️ Ready');
    }, 1500);
}

// ============================================================================
// OVERVIEW
// ============================================================================

function showOverview() {
    showPage('overviewPage');
    document.querySelectorAll('.nav-bar button').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.nav-bar button')[1].classList.add('active');
}

function refreshNews() {
    const container = document.getElementById('newsContainer');
    const news = [
        { title: '🌍 Global AI Summit 2026 announces breakthroughs', time: 'Just now' },
        { title: '💰 Tech giants report record earnings', time: '2 min ago' },
        { title: '🚀 SpaceX completes historic mission', time: '10 min ago' },
        { title: '🌡️ Climate tech innovations unveiled', time: '25 min ago' },
        { title: '🎮 AI-powered gaming reaches new level', time: '45 min ago' },
        { title: '🏥 Medical AI detects disease early', time: '1 hour ago' },
        { title: '🎓 AI education programs expand globally', time: '2 hours ago' }
    ];
    container.innerHTML = news.map(n => `
        <div class="news-item">
            <div class="title">${n.title}</div>
            <div class="time">${n.time}</div>
        </div>
    `).join('');
    addStatus('📊 News refreshed');
}

// ============================================================================
// RESEARCH
// ============================================================================

function showResearch() {
    showPage('researchPage');
    document.querySelectorAll('.nav-bar button').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.nav-bar button')[2].classList.add('active');
}

function searchTopic(topic) {
    window.open(`https://www.google.com/search?q=${topic}`, '_blank');
    showNotification('Research', `Opening: ${topic}`, '🔬');
}

// ============================================================================
// PROFILE
// ============================================================================


function showProfile() {
    showPage('profilePage');
    document.querySelectorAll('.nav-bar button').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.nav-bar button')[3].classList.add('active');
}

function editPhoto() {
    // Simulate photo upload
    showNotification('Profile', '📸 Photo editor opened\nChoose a new profile picture', '📸');
}

function updateProfile() {
    const name = document.getElementById('profileName').value;
    const bio = document.getElementById('profileBio').value;
    showNotification('Success', `✅ Profile updated!\n👤 Name: ${name}\n📝 Bio: ${bio}`);
}

function clearChat() {
    if (confirm('⚠️ Clear all chat history?')) {
        const display = document.getElementById('chatDisplay');
        display.innerHTML = `
            <div class="message ai">
                <div class="sender">HPMI</div>
                <div class="content">💬 Chat history cleared.<br>How can I help you today?</div>
            </div>
            <div class="status">⏺️ Ready</div>
        `;
        showNotification('Done', '🗑️ Chat history cleared');
    }
}

function clearData() {
    if (confirm('⚠️ WARNING: Delete ALL data permanently?')) {
        showNotification('Done', '🗑️ All data cleared successfully');
        logout();
    }
}

function logout() {
    if (confirm('🚪 Logout?')) {
        state.user = null;
        showLogin();
    }
}

function checkUpdate() {
    showNotification('Update Check', '✅ HPMI is up to date!\n📡 Version: 2.0.0\n⚡ All systems optimal');
}

// ============================================================================
// INIT
// ============================================================================

// Load chat history from localStorage
function loadChatHistory() {
    try {
        const history = JSON.parse(localStorage.getItem('hpmi_chat_history') || '[]');
        history.forEach(msg => {
            const sender = msg.type === 'user' ? 'You' : 'HPMI';
            addMessage(sender, msg.content, msg.type);
        });
        addStatus('⏺️ Ready');
    } catch(e) {}
}

// Save chat history
function saveChatHistory(msg, type) {
    try {
        const history = JSON.parse(localStorage.getItem('hpmi_chat_history') || '[]');
        history.push({ content: msg, type, time: Date.now() });
        localStorage.setItem('hpmi_chat_history', JSON.stringify(history));
    } catch(e) {}
}

// Override addMessage to save history
const originalAddMessage = addMessage;
addMessage = function(sender, content, type = 'ai') {
    originalAddMessage(sender, content, type);
    if (type !== 'status' && type !== 'typing') {
        const msgType = type === 'user' ? 'user' : 'ai';
        saveChatHistory(content, msgType);
    }
};

// ============================================================================
// STARTUP
// ============================================================================

console.log('⚡ HPMI v2.0.0 - Neural Engine Active');
console.log('🐻‍❄️ Powered by HPMI AI');

// Check for dark mode preference
if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    toggleTheme();
}

// Load chat history if available
setTimeout(() => {
    const display = document.getElementById('chatDisplay');
    // Only load if no messages
    if (display.children.length <= 2) {
        // Don't auto-load to prevent duplicates
    }
}, 500);

</script>

</body>
</html>
