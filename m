<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>寂静特训 | 移动沉浸版</title>
    <style>
        :root { --gold-l: #f9e194; --gold-m: #d4a73f; --gold-d: #7a5a12; --black-b: #080808; --red-glow: #ff3b30; }
        * { -webkit-tap-highlight-color: transparent; box-sizing: border-box; }
        body, html { margin: 0; padding: 0; height: 100%; background: #000; overflow: hidden; font-family: "PingFang SC", sans-serif; color: white; user-select: none; }

        /* 视频背景：适配 9:16 竖屏 */
        #v-bg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; display: none; }

        /* 按钮与通用 UI */
        .btn-base { background: rgba(0,0,0,0.6); border: 1px solid var(--gold-m); color: var(--gold-m); border-radius: 4px; padding: 12px 24px; font-size: 14px; pointer-events: auto; transition: 0.2s; }
        .btn-base:active { background: var(--gold-m); color: black; }
        
        #back-home { position: fixed; top: env(safe-area-inset-top, 25px); left: 20px; z-index: 8000; display: none; }

        /* 角色轮播 (Carousel) */
        #selection-ui { position: relative; width: 100%; height: 100%; z-index: 10; display: none; overflow: hidden; background: radial-gradient(circle at center, #1a1a1a 0%, #000 100%); }
        .carousel-container { display: flex; height: 100%; transition: transform 0.6s cubic-bezier(0.15, 1, 0.3, 1); }
        .char-slide { min-width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; padding-bottom: 8vh; }
        .char-portrait { width: 100%; height: 80vh; background-size: contain; background-repeat: no-repeat; background-position: center bottom; }
        .char-info-box { width: 85%; background: rgba(0,0,0,0.8); border-left: 4px solid var(--gold-m); padding: 20px; margin-bottom: 20px; backdrop-filter: blur(5px); }

        /* 移动端模态框 */
        .mobile-modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.96); z-index: 9000; display: none; flex-direction: column; justify-content: center; align-items: center; padding: 40px; }
        .mode-option { width: 100%; padding: 20px; margin: 10px 0; background: none; border: 1px solid #333; color: #aaa; font-weight: bold; font-size: 16px; }
        .mode-option.active { border-color: var(--gold-m); color: var(--gold-m); }

        /* 计时器面板 */
        .timer-panel { position: absolute; bottom: calc(env(safe-area-inset-bottom, 20px) + 20px); left: 50%; transform: translateX(-50%); width: 90%; background: rgba(0,0,0,0.75); border: 1px solid var(--gold-d); border-radius: 15px; padding: 20px; z-index: 500; backdrop-filter: blur(15px); }
        #timer { font-size: 64px; font-family: 'Courier New', monospace; color: var(--gold-l); text-align: center; font-weight: bold; }
        
        /* 签到系统 UI */
        .star-grid { display: grid; grid-template-columns: repeat(10, 1fr); gap: 6px; margin: 15px 0; }
        .star { font-size: 12px; color: #222; transition: 0.3s; }
        .star.active { color: var(--gold-m); text-shadow: 0 0 5px var(--gold-m); }

        .swipe-hint { position: absolute; top: 50px; width: 100%; text-align: center; font-size: 12px; color: var(--gold-m); letter-spacing: 2px; opacity: 0.5; }
    </style>
</head>
<body onclick="tryFullScreen()">

    <div id="entry-mask" style="position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10000; display:flex; flex-direction:column; justify-content:center; align-items:center;">
        <h2 style="color:var(--gold-m); letter-spacing:8px; margin-bottom:30px;">白塔序列接入</h2>
        <input type="password" id="auth-code" placeholder="ENTER ACCESS CODE" style="background:#111; border:1px solid var(--gold-d); color:white; padding:15px; text-align:center; width:250px; border-radius:0; margin-bottom:25px;">
        <button onclick="verifyAccess()" class="btn-base" style="width:250px; letter-spacing:4px;">身份确认</button>
    </div>

    <button id="back-home" class="btn-base" onclick="backToHall()">◀ 返回大厅</button>

    <div id="selection-ui">
        <div class="swipe-hint">左右滑动切换监考官</div>
        <div class="carousel-container" id="carousel">
            <div class="char-slide" onclick="openMode('chi')">
                <div class="char-portrait" style="background-image:url('../shen.png')"></div>
                <div class="char-info-box">
                    <div style="font-size:26px; font-weight:bold; color:var(--gold-l); letter-spacing:5px;">迟 砚</div>
                    <div style="font-size:13px; color:#ccc; margin-top:8px; line-height:1.5;">“笔尖停得太久了。如果不想要这双手，我可以帮帮你。”</div>
                </div>
            </div>
            <div class="char-slide" onclick="openMode('lin')">
                <div class="char-portrait" style="background-image:url('../lin.png')"></div>
                <div class="char-info-box">
                    <div style="font-size:26px; font-weight:bold; color:var(--gold-l); letter-spacing:5px;">林 深</div>
                    <div style="font-size:13px; color:#ccc; margin-top:8px; line-height:1.5;">“乖一点。等计时器归零，我会给你想要的奖励。”</div>
                </div>
            </div>
        </div>
    </div>

    <div id="mode-modal" class="mobile-modal">
        <div style="color:var(--gold-m); margin-bottom:30px; font-weight:bold;">选择训练逻辑</div>
        <button class="mode-option" onclick="launch(1)">陪伴模式 (COMPANION)</button>
        <button class="mode-option" style="color:var(--red-glow); border-color:var(--red-glow);" onclick="launch(3)">监管模式 (REGULATION)</button>
        <button onclick="this.parentElement.style.display='none'" style="margin-top:30px; color:#555; background:none; border:none; text-decoration:underline;">关闭</button>
    </div>

    <div id="focus-mode" style="display:none; position:relative; width:100%; height:100%;">
        <video id="v-bg" playsinline muted loop></video>
        <div class="timer-panel">
            <div id="timer">25:00</div>
            <div class="star-grid" id="star-g"></div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <button onclick="doSign()" class="btn-base" style="font-size:12px; padding:8px 15px;">每日签到</button>
                <div id="gift" onclick="alert('累计签到30天解锁绝密奖励卡面')" style="font-size:24px; filter:grayscale(1); opacity:0.5;">🎁</div>
            </div>
            <button id="ctrl-btn" onclick="toggleTimer()" class="btn-base" style="width:100%; margin-top:15px; background:var(--gold-m); color:black; font-weight:900; letter-spacing:3px;">开始特训</button>
        </div>
    </div>

    <audio id="v-player"></audio>
    <audio id="m-player" loop></audio>

    <script>
        // 安全校验
        const _0x1a2b = ["\x57\x61\x73\x65\x64\x61\x32\x30\x32\x36"];
        let state = { man: '', mode: '', active: false, time: 1500, curIdx: 0, touchX: 0, timerInterval: null };

        function verifyAccess() {
            const input = document.getElementById('auth-code').value;
            if (input === _0x1a2b[0]) {
                document.getElementById('entry-mask').style.display = 'none';
                document.getElementById('selection-ui').style.display = 'block';
                initCarousel();
                // 播放背景音
                const mp = document.getElementById('m-player');
                mp.src = '../bgm_1.mp3';
                mp.volume = 0.3;
                mp.play().catch(e=>{});
            } else {
                alert("身份校验失败");
            }
        }

        function initCarousel() {
            const el = document.getElementById('selection-ui');
            const inner = document.getElementById('carousel');
            el.addEventListener('touchstart', e => state.touchX = e.touches[0].clientX);
            el.addEventListener('touchend', e => {
                const diff = state.touchX - e.changedTouches[0].clientX;
                if (Math.abs(diff) > 60) {
                    state.curIdx = diff > 0 ? Math.min(state.curIdx + 1, 1) : Math.max(state.curIdx - 1, 0);
                    inner.style.transform = `translateX(-${state.curIdx * 100}%)`;
                    if(window.navigator.vibrate) window.navigator.vibrate(15);
                }
            });
        }

        function openMode(m) {
            state.man = m;
            const vp = document.getElementById('v-player');
            vp.src = `../${m}_select.wav`;
            vp.play();
            document.getElementById('mode-modal').style.display = 'flex';
        }

        function launch(mode) {
            state.mode = mode;
            document.getElementById('mode-modal').style.display = 'none';
            document.getElementById('selection-ui').style.display = 'none';
            document.getElementById('focus-mode').style.display = 'block';
            document.getElementById('back-home').style.display = 'block';
            
            const v = document.getElementById('v-bg');
            v.style.display = 'block';
            v.src = `../${state.man == 'chi' ? 'shen' : 'lin'}_work.mp4`;
            v.play();
            renderStars();
        }

        function toggleTimer() {
            const btn = document.getElementById('ctrl-btn');
            state.active = !state.active;
            btn.innerText = state.active ? "监控中..." : "恢复特训";
            if(state.active) {
                state.timerInterval = setInterval(() => {
                    if(state.time > 0) {
                        state.time--;
                        updateTimerUI();
                        if(Math.random() < 0.003) triggerCheck();
                    } else {
                        clearInterval(state.timerInterval);
                        alert("特训结束");
                    }
                }, 1000);
            } else {
                clearInterval(state.timerInterval);
            }
        }

        function triggerCheck() {
            const v = document.getElementById('v-bg');
            const originalSrc = v.src;
            v.src = `../${state.man == 'chi' ? 'shen' : 'lin'}_look.mp4`;
            v.loop = false;
            v.play();
            v.onended = () => {
                v.src = originalSrc;
                v.loop = true;
                v.play();
            };
        }

        function backToHall() {
            state.active = false;
            clearInterval(state.timerInterval);
            document.getElementById('focus-mode').style.display = 'none';
            document.getElementById('back-home').style.display = 'none';
            document.getElementById('selection-ui').style.display = 'block';
            document.getElementById('v-bg').pause();
        }

        function updateTimerUI() {
            const m = Math.floor(state.time / 60);
            const s = (state.time % 60).toString().padStart(2, '0');
            document.getElementById('timer').innerText = `${m}:${s}`;
        }

        function doSign() {
            const key = `_sk_mobile_${state.man}_save`;
            let count = parseInt(localStorage.getItem(key) || 0);
            count = Math.min(count + 1, 30);
            localStorage.setItem(key, count);
            renderStars();
            alert("打卡成功，存档已加密保存。");
        }

        function renderStars() {
            const count = parseInt(localStorage.getItem(`_sk_mobile_${state.man}_save`) || 0);
            const g = document.getElementById('star-g');
            g.innerHTML = '';
            for(let i=0; i<30; i++) {
                g.innerHTML += `<div class="star ${i < count ? 'active' : ''}">✦</div>`;
            }
            if(count >= 30) document.getElementById('gift').style.filter = 'none';
        }

        function tryFullScreen() {
            const docEl = window.document.documentElement;
            const requestFullScreen = docEl.requestFullscreen || docEl.webkitRequestFullScreen;
            if(requestFullScreen) requestFullScreen.call(docEl);
        }
    </script>
</body>
</html>
