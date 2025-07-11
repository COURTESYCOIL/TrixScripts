// --- TriX AI Standalone Script for TriX Executor ---
// v1.2.2 - This script injects the TriX AI assistant sidebar into the page.
// It relies on the parent Executor to provide GM_addStyle and html2canvas via the TriX API.

(function() {
    if (document.getElementById('trix-ai-sidebar')) {
        TriX.log('TriX AI is already running.', 'warn');
        return;
    }

    TriX.log('Injecting TriX AI Assistant...', 'info');

    const TriXAI = {
        isSidebarOpen: false, isInspecting: false, isGameAssistActive: false, lastHighlighted: null,

        init() {
            this.injectDependencies();
            this.injectHTML();
            this.attachEventListeners();
            this.addMessage('Hello! I am TriX AI. Type <strong>/help</strong> to see what I can do.', 'bot');
            this.toggleSidebar(); // Open automatically on injection
        },

        injectDependencies() {
            if (typeof TriX.GM_addStyle !== 'function') {
                TriX.log('GM_addStyle not provided by executor. UI may be unstyled.', 'error');
                return;
            }
            TriX.GM_addStyle(`
                @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');
                :root {
                    --ai-bg-primary: #1e202b; --ai-bg-secondary: #2a2d3d; --ai-bg-input: #3b405c;
                    --ai-accent-blue: #00bfff; --ai-accent-green: #28a745; --ai-accent-red: #f7768e; 
                    --ai-text-primary: #e0e0e0; --ai-text-secondary: #a0a0a0; --ai-border-color: #353952;
                }
                #trix-ai-toggle {
                    position: fixed; left: 20px; top: 50%; transform: translateY(-50%); z-index: 1000001;
                    width: 50px; height: 50px; background-color: var(--ai-accent-blue); color: white;
                    border: none; border-radius: 50%; cursor: pointer; box-shadow: 0 4px 15px rgba(0, 191, 255, 0.4);
                    display: flex; align-items: center; justify-content: center; font-size: 24px;
                    transition: all 0.3s ease;
                }
                #trix-ai-toggle:hover { transform: translateY(-50%) scale(1.1); }
                #trix-ai-sidebar {
                    position: fixed; top: 0; left: 0; width: 380px; max-width: 90vw; height: 100%;
                    background-color: var(--ai-bg-primary); box-shadow: 5px 0 25px rgba(0,0,0,0.3); z-index: 1000000;
                    display: flex; flex-direction: column; transform: translateX(-100%);
                    transition: transform 0.4s cubic-bezier(0.25, 1, 0.5, 1); font-family: 'Poppins', sans-serif;
                }
                #trix-ai-sidebar.open { transform: translateX(0); }
                body.inspecting { cursor: crosshair !important; }
                .ai-header { padding: 15px 20px; background-color: var(--ai-bg-secondary); color: var(--ai-text-primary); font-size: 18px; font-weight: 600; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--ai-border-color); }
                .ai-header .close-btn { font-size: 24px; cursor: pointer; transition: color 0.2s; }
                .ai-header .close-btn:hover { color: var(--ai-accent-blue); }
                .ai-messages { flex-grow: 1; padding: 20px; overflow-y: auto; display: flex; flex-direction: column; gap: 15px; }
                .ai-message { padding: 12px 18px; border-radius: 18px; max-width: 85%; line-height: 1.5; animation: pop-in 0.3s cubic-bezier(0.18, 0.89, 0.32, 1.28); }
                @keyframes pop-in { 0% { transform: scale(0.8); opacity: 0; } 100% { transform: scale(1); opacity: 1; } }
                .ai-message.user { background-color: var(--ai-accent-blue); color: white; align-self: flex-end; border-bottom-right-radius: 4px; }
                .ai-message.bot { background-color: var(--ai-bg-secondary); color: var(--ai-text-primary); align-self: flex-start; border-bottom-left-radius: 4px; }
                .ai-message strong { color: var(--ai-accent-cyan, #7dcfff); font-weight: 600; }
                .ai-message pre { background-color: rgba(0,0,0,0.2); padding: 10px; border-radius: 8px; font-size: 13px; white-space: pre-wrap; word-wrap: break-word; font-family:monospace; }
                .typing-indicator { display: flex; gap: 5px; align-items: center; padding: 12px 18px; }
                .typing-indicator span { width: 8px; height: 8px; border-radius: 50%; background-color: var(--ai-text-secondary); animation: typing-bounce 1.2s infinite ease-in-out; }
                .typing-indicator span:nth-child(2) { animation-delay: -1s; }
                .typing-indicator span:nth-child(3) { animation-delay: -0.8s; }
                @keyframes typing-bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1.0); } }
                .ai-input-area { padding: 15px; border-top: 1px solid var(--ai-border-color); display: flex; gap: 10px; }
                #ai-input { flex-grow: 1; border: none; background-color: var(--ai-bg-input); border-radius: 8px; padding: 12px 15px; color: var(--ai-text-primary); font-size: 15px; outline: 0; }
                #ai-send-btn { border: none; background-color: var(--ai-accent-blue); color: white; border-radius: 8px; padding: 0 20px; cursor: pointer; font-weight: 600; transition: background-color .2s; }
                #ai-send-btn:hover { background-color: #00a0d8; }
                #trix-ai-screenshot-modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.7); z-index: 1000001; display: flex; align-items: center; justify-content: center; backdrop-filter: blur(5px); }
                .screenshot-container { padding: 20px; background-color: var(--ai-bg-secondary); border-radius: 10px; max-width: 90vw; max-height: 90vh; overflow: auto; display: flex; flex-direction: column; gap: 15px; }
                .screenshot-container img { max-width: 100%; border-radius: 5px; }
            `);
        },
        injectHTML:function(){const e=`<button id="trix-ai-toggle">🤖</button>`,t=`<div id="trix-ai-sidebar"><div class="ai-header"><span>TriX AI Assistant</span><span class="close-btn">✕</span></div><div class="ai-messages"></div><div class="ai-input-area"><input type="text" id="ai-input" placeholder="Type a command..."><button id="ai-send-btn">Send</button></div></div>`;document.body.insertAdjacentHTML("beforeend",e),document.body.insertAdjacentHTML("beforeend",t)},
        attachEventListeners:function(){document.getElementById("trix-ai-toggle").addEventListener("click",()=>this.toggleSidebar()),document.querySelector(".ai-header .close-btn").addEventListener("click",()=>this.toggleSidebar());const e=document.getElementById("ai-input"),t=document.getElementById("ai-send-btn");t.addEventListener("click",()=>this.handleUserInput()),e.addEventListener("keydown",e=>{"Enter"===e.key&&(e.preventDefault(),this.handleUserInput())})},
        toggleSidebar:function(){this.isSidebarOpen=!this.isSidebarOpen,document.getElementById("trix-ai-sidebar").classList.toggle("open",this.isSidebarOpen),document.getElementById("trix-ai-toggle").style.display=this.isSidebarOpen?"none":"flex"},
        addMessage:function(e,t){const i=document.querySelector(".ai-messages"),s=document.createElement("div");s.classList.add("ai-message",t),s.innerHTML=e,i.appendChild(s),i.scrollTop=i.scrollHeight},
        handleUserInput:function(){const e=document.getElementById("ai-input"),t=e.value.trim();t&&(this.addMessage(t,"user"),e.value="",this.processCommand(t))},
        showTyping:function(){const e=document.querySelector(".ai-messages");if(e.querySelector(".typing-indicator"))return;const t=document.createElement("div");t.className="typing-indicator",t.innerHTML="<span></span><span></span><span></span>",e.appendChild(t),e.scrollTop=e.scrollHeight},
        hideTyping:function(){const e=document.querySelector(".typing-indicator");e&&e.remove()},
        async processCommand(command){this.showTyping(),await new Promise(e=>setTimeout(e,800)),this.hideTyping(),"/initiate-game-assist"===command.toLowerCase()?this.analyzeAndAdvise():eval(`switch(command.toLowerCase()){case"/help":this.addMessage('Available commands:<ul><li><strong>/help</strong> - Shows this message.</li><li><strong>/screenshot</strong> - Captures the current view.</li><li><strong>/inspect</strong> - Allows you to inspect an element.</li><li><strong>/initiate-game-assist</strong> - Performs a one-time gameplay analysis.</li></ul>',"bot");break;case"/screenshot":this.takeScreenshot();break;case"/inspect":this.startInspector();break;default:this.addMessage("I don't recognize that command. Type <strong>/help</strong> for a list of commands.","bot")}`)},
        takeScreenshot(){this.addMessage("Rendering screenshot...","bot");if("function"!=typeof TriX.html2canvas)return void this.addMessage("Error: `html2canvas` library not found in Executor. Screenshots are unavailable.","bot");TriX.html2canvas(document.body,{useCORS:!0,allowTaint:!0}).then(e=>{const t=e.getContext("2d");t.fillStyle="rgba(255, 255, 255, 0.7)",t.font="bold 16px Poppins",t.textAlign="right",t.textBaseline="bottom",t.fillText("Captured by TriX AI",e.width-15,e.height-15);const i=document.createElement("div");i.id="trix-ai-screenshot-modal";const s=e.toDataURL("image/png");i.innerHTML=`<div class="screenshot-container"><img src="${s}" alt="Screenshot"><div style="display:flex;gap:10px;"><a href="${s}" download="trix-screenshot.png" style="text-decoration:none;padding:10px 15px;background:var(--ai-accent-green);border-radius:5px;color:white;">Download</a><button id="screenshot-close-btn" style="padding:10px 15px;background:var(--ai-accent-red);border-radius:5px;color:white;border:none;cursor:pointer;">Close</button></div></div>`,document.body.appendChild(i),document.getElementById("screenshot-close-btn").addEventListener("click",()=>i.remove())}).catch(e=>{this.addMessage("Sorry, I failed to capture the screen.","bot")})},
        startInspector:function(){if(this.isInspecting)return;this.isInspecting=!0,this.addMessage("Inspector activated. Click on any element to analyze it.","bot"),document.body.classList.add("inspecting");const e=e=>{const t=e.target;this.lastHighlighted&&this.lastHighlighted!==t&&(this.lastHighlighted.style.outline=""),t&&!t.closest("#trix-ai-sidebar, #trix-ai-toggle")&&(t.style.outline="2px dashed var(--ai-accent-blue)",this.lastHighlighted=t)},t=i=>{i.preventDefault(),i.stopPropagation();const s=i.target;if(document.body.classList.remove("inspecting"),this.lastHighlighted&&(this.lastHighlighted.style.outline=""),document.removeEventListener("mousemove",e),document.removeEventListener("click",t,!0),this.isInspecting=!1,s.closest("#trix-ai-sidebar, #trix-ai-toggle"))this.addMessage("Inspection cancelled. You can't inspect the AI panel.","bot");else{const e=s.tagName.toLowerCase(),t=s.id?`#${s.id}`:"",i=s.className?`.${s.className.toString().trim().replace(/\s+/g,".")}`:"",o=`${e}${t}${i}`;let n=s.textContent.trim();n=n.length>80?n.substring(0,80)+"...":n;const l=`<strong>Element Analysis:</strong><pre>Tag: ${e}\nID: ${t||"none"}\nClasses: ${i||"none"}\nContent: "${n||"none"}"\n\nSelector:\n${o}</pre>`;this.addMessage(l,"bot")}};document.addEventListener("mousemove",e),document.addEventListener("click",t,{capture:!0,once:!0})},
        analyzeAndAdvise:function(){this.showTyping(),setTimeout(()=>{this.hideTyping();let e="<strong>Heuristic Analysis Complete:</strong><br>";null!==document.querySelector("#input0")?.offsetParent?e+="You are on the main menu. Your primary objective should be to join a game.<pre>Action: Click 'Multiplayer' or 'Custom Scenario'.</pre>":document.querySelector("#playerList")?e+="You are in a <strong>Game Lobby or Scoreboard</strong>.<pre>Suggested Action: Prepare for the next match.</pre>":e+=`You appear to be in an <strong>Active Game</strong>.<pre>Strategy: ${["Focus on expanding your borders.","Reinforce key defensive positions.","An aggressive push might catch an opponent off guard.","Consolidate your territories and build up your forces."][Math.floor(4*Math.random())]}</pre>`,e+="<br><small><i>Disclaimer: This is a simulated analysis based on page structure.</i></small>",this.addMessage(e,"bot")},1200)}
    };
    TriXAI.init();
})();
