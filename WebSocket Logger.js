// --- TriX WebSocket Network Logger ---
// v1.2 - Formats binary data as a readable array of integers.
// Execute this script from the main TriX Executor to activate the network logger.

(function() {
    if (window.isTriXWSLoggerActive) {
        TriX.log('WebSocket Logger is already active.', 'warn');
        return;
    }
    window.isTriXWSLoggerActive = true;
    window.trixActiveSocket = null;

    TriX.log('Initializing WebSocket Network Logger v1.2...', 'info');

    function setupNetworkUI() {
        const trixTabs = document.getElementById('trix-editor-tabs');
        const rightPanel = document.getElementById('trix-right-panel');

        // Add "Network" Tab Button
        const networkTabBtn = document.createElement('button');
        networkTabBtn.className = 'trix-editor-tab-btn';
        networkTabBtn.dataset.tab = 'network';
        networkTabBtn.textContent = 'Network';
        trixTabs.appendChild(networkTabBtn);

        // Add "Network" Pane
        const networkPane = document.createElement('div');
        networkPane.id = 'network-pane';
        networkPane.className = 'trix-editor-pane';
        networkPane.style.flexDirection = 'column';
        networkPane.style.padding = '10px';
        networkPane.innerHTML = `
            <div style="margin-bottom: 10px; display: flex; align-items: center; gap: 15px;">
                <label style="color: var(--trix-text-secondary); font-size: 13px;">
                    <input type="checkbox" id="trix-ws-logging-toggle" checked> Enable Logging
                </label>
                <button id="trix-ws-clear-log" class="trix-button" style="padding: 5px 10px;">Clear Log</button>
            </div>
            <div id="trix-ws-log" style="background-color: #16161e; border: 1px solid #4a4a4a; flex-grow: 1; overflow-y: auto; font-family: 'Fira Code', monospace; font-size: 12px; color: var(--trix-text-primary);"></div>
        `;
        rightPanel.insertBefore(networkPane, document.getElementById('trix-console'));

        networkTabBtn.addEventListener('click', () => {
            document.querySelectorAll('.trix-editor-pane').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.trix-editor-tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(`network-pane`).classList.add('active');
            networkTabBtn.classList.add('active');
        });
        
        document.getElementById('trix-ws-clear-log').addEventListener('click', () => {
            document.getElementById('trix-ws-log').innerHTML = '';
        });
    }
    
    const OriginalWebSocket = window.WebSocket;
    const logContainer = () => document.getElementById('trix-ws-log');
    const loggingEnabled = () => document.getElementById('trix-ws-logging-toggle')?.checked;

    function logMessage(direction, data) {
        if (!loggingEnabled() || !logContainer()) return;
        const logEntry = document.createElement('div');
        const isOutgoing = direction === 'SENT';
        const color = isOutgoing ? '#7dcfff' : '#9ece6a';
        logEntry.style.cssText = 'padding:4px 8px;border-bottom:1px solid #2d2d2d;white-space:pre-wrap;word-break:break-all;';
        let formattedData;
        if (data instanceof ArrayBuffer) {
            const byteArray = new Uint8Array(data);
            formattedData = `[${Array.from(byteArray).join(', ')}]`;
        } else {
            formattedData = data;
        }
        const content = `<strong>[${direction}]</strong> ${formattedData}`;
        logEntry.innerHTML = `<span style="color: ${color};">${content}</span>`;
        logContainer().appendChild(logEntry);
        logContainer().scrollTop = logContainer().scrollHeight;
    }

    window.WebSocket = function(url, protocols) {
        TriX.log(`New WebSocket connection initiated to: ${url}`, 'info');
        const wsInstance = protocols ? new OriginalWebSocket(url, protocols) : new OriginalWebSocket(url);
        window.trixActiveSocket = wsInstance;
        TriX.log('Active socket stored in `window.trixActiveSocket`.', 'info');
        const originalSend = wsInstance.send;
        wsInstance.send = function(data) { logMessage('SENT', data); return originalSend.call(this, data); };
        Object.defineProperty(wsInstance, 'onmessage', {
            set: function(callback) {
                this._onmessage = callback;
                this.addEventListener('message', (event) => {
                    logMessage('RECV', event.data);
                    if (this._onmessage) this._onmessage.call(this, event);
                });
            }
        });
        wsInstance.addEventListener('close', () => { if(window.trixActiveSocket === wsInstance) { TriX.log('Active WebSocket connection closed. Clearing global reference.', 'warn'); window.trixActiveSocket = null; }});
        return wsInstance;
    };
    
    window.WebSocket.CONNECTING = OriginalWebSocket.CONNECTING;
    window.WebSocket.OPEN = OriginalWebSocket.OPEN;
    window.WebSocket.CLOSING = OriginalWebSocket.CLOSING;
    window.WebSocket.CLOSED = OriginalWebSocket.CLOSED;

    setupNetworkUI();
    TriX.log('WebSocket Logger is now active. Refresh the page to capture new connections.', 'info');
})();
