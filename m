<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>寂静特训 | 移动沉浸版</title>
    <style>
        :root { --gold-l: #f9e194; --gold-m: #d4a73f; --gold-d: #7a5a12; --black-b: #080808; --red: #8b0000; --red-glow: #ff3b30; }
        * { -webkit-tap-highlight-color: transparent; box-sizing: border-box; }
        body, html { margin: 0; padding: 0; height: 100%; background: #000; overflow: hidden; font-family: "PingFang SC", sans-serif; color: white; user-select: none; }
        #v-bg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; display: none; }
        .btn-base { background: rgba(0,0,0,0.6); border: 1px solid var(--gold-m); color: var(--gold-m); border-radius: 4px; padding: 12px 24px; font-size: 14px; pointer-events: auto; }
        #back-home { position: fixed; top: env(safe-area-inset-top, 25px); left: 20px; z-index: 8000; display: none; }
        #selection-ui { position: relative; width: 100%; height: 100%; z-index: 10; display: none; overflow: hidden; background: radial-gradient(circle at center, #181818 0%, #000 100%); }
        .carousel-container { display: flex; height: 100%; transition: transform 0.6s cubic-bezier(0.15, 1, 0.3, 1); }
        .char-slide { min-width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; padding-bottom: 8vh; }
        .char-portrait { width: 100%; height: 82vh; background-size: contain; background-repeat: no-repeat; background-position: center bottom; }
        .char-info-box { width: 85%; background: rgba(0,0,0,0.88); border-left: 5px solid var(--gold-m); padding: 25px; margin-bottom: 20px; backdrop-filter: blur(10px); }
        .timer-panel { position: absolute; bottom: calc(env(safe-area-inset-bottom, 20px) + 20px); left: 50%; transform: translateX(-50%); width: 90%; background: rgba(0,0,0,0.7); border: 1px solid var(--gold-m); border-radius: 20px; padding: 20px; z-index: 500; backdrop-filter: blur(15px); }
        #timer { font-size: 60px; font-family: 'Courier New', monospace; color: var(--gold-l); text-align: center; font-weight: bold; }
        .star-grid { display: grid; grid-template-columns: repeat(10, 1fr); gap: 6px; margin: 15px 0; }
        .star { font-size: 12px; color: #1a1a1a; transition: 0.5s; }
        .star.active { color: var(--gold-m); text-shadow: 0 0 10px var(--gold-m); }
        #gallery-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.95); z-index: 9000; display: none; flex-direction: column; align-items: center; justify-content: center; padding: 20px; }
        .reward-card-m { width: 80vw; height: 106.6vw; border: 1px solid #222; position: relative; overflow: hidden; filter: grayscale(1); transition: 0.5s; background: #0a0a0a; }
        .reward-card-m.active { filter: grayscale(0); border-color: var(--gold-m); }
        .reward-card-m img { width: 100%; height: 100%; object-fit: cover; opacity: 0.4; }
        .reward-card-m.active img { opacity: 1; }
        .reward-intro { position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(to top, rgba(0,0,0,0.95) 70%, transparent); padding: 20px; z-index: 10; }
        .reward-story { font-size: 12px; color: #ddd; line-height: 1.6; white-space: pre-line; margin-top: 8px; }
        .lock-badge { position: absolute; top: 15px; right: 15px; background: var(--red); color: #fff; font-size: 10px; padding: 4px 10px; border-radius: 4px; z-index: 20; }
        .swipe-hint { position: absolute; top: 60px; width: 100%; text-align: center; color: var(--gold-m); font-size: 12px; letter-spacing: 3px; opacity: 0.6; }
    </style>
</head>
<body onclick="tryFullScreen()">

    <div id="entry-mask" style="position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10000; display:flex; flex-direction:column; justify-content:center; align-items:center;">
        <h2 style="color:var(--gold-m); letter-spacing:10px; margin-bottom:40px;">白塔序列接入</h2>
        <input type="password" id="auth-code" placeholder="ACCESS CODE" style="background:#111; border:1px solid var(--gold-d); color:white; padding:15px; text-align:center; width:260px; outline:none; border-radius:0;">
        <button onclick="_0x5a21()" class="btn-base" style="width:260px; letter-spacing:5px; margin-top:30px;">确认接入</button>
    </div>

    <button id="back-home" class="btn-base" onclick="backToHall()">◀ BACK TO HALL</button>

    <div id="selection-ui">
        <div class="swipe-hint">左右滑动切换监考官</div>
        <div class="carousel-container" id="carousel">
            <div class="char-slide" onclick="openMode('chi')">
                <div class="char-portrait" style="background-image:url('../shen.png')"></div>
                <div class="char-info-box">
                    <div style="font-size:28px; font-weight:bold; color:var(--gold-l); letter-spacing:6px;">迟 砚</div>
                    <div style="font-size:13px; color:#ccc; margin-top:10px; line-height:1.6;">“笔尖停得太久了。如果不想要这双手，我可以帮帮你。”</div>
                </div>
            </div>
            <div class="char-slide" onclick="openMode('lin')">
                <div class="char-portrait" style="background-image:url('../lin.png')"></div>
                <div class="char-info-box">
                    <div style="font-size:28px; font-weight:bold; color:var(--gold-l); letter-spacing:6px;">林 深</div>
                    <div style="font-size:13px; color:#ccc; margin-top:10px; line-height:1.6;">“乖一点。等计时器归零，我会给你想要的奖励。”</div>
                </div>
            </div>
        </div>
    </div>

    <div id="focus-mode" style="display:none; position:relative; width:100%; height:100%;">
        <video id="v-bg" playsinline muted loop></video>
        <div class="timer-panel">
            <div id="timer">25:00</div>
            <div class="star-grid" id="star-g"></div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <button onclick="doSign()" class="btn-base" style="font-size:12px; padding:10px 20px;">CHECK-IN</button>
                <div id="gift" onclick="showGallery()" style="font-size:30px;">🎁</div>
            </div>
            <button id="ctrl-btn" onclick="toggleTimer()" class="btn-base" style="width:100%; margin-top:20px; background:var(--gold-m); color:black; font-weight:900; letter-spacing:5px;">START</button>
        </div>
    </div>

    <div id="gallery-overlay" onclick="if(event.target == this) hideGallery()">
        <h3 id="gallery-title" style="color:var(--gold-m); letter-spacing:5px; margin-bottom:20px;"></h3>
        <div id="reward-main" class="reward-card-m" onclick="playReward()">
            <div id="lock-badge" class="lock-badge">未授权</div>
            <img id="reward-img" src="">
            <div class="reward-intro">
                <div id="reward-title-text" style="color:var(--gold-m); font-weight:bold; font-size:18px;"></div>
                <div id="reward-story-text" class="reward-story"></div>
            </div>
        </div>
        <button onclick="hideGallery()" style="margin-top:30px; color:#666; background:none; border:none; text-decoration:underline;">关闭记录</button>
    </div>

    <div id="mode-modal" style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.98); z-index:9000; display:none; flex-direction:column; justify-content:center; align-items:center; padding:40px;">
        <div style="color:var(--gold-m); margin-bottom:40px; font-weight:bold; letter-spacing:4px;">选择特训逻辑</div>
        <button class="btn-base" style="width:100%; margin:15px 0; padding:20px;" onclick="launch(1)">陪伴模式</button>
        <button class="btn-base" style="width:100%; margin:15px 0; padding:20px; border-color:var(--red); color:var(--red);" onclick="launch(3)">监管模式</button>
        <button onclick="this.parentElement.style.display='none'" style="margin-top:30px; color:#555; background:none; border:none;">取消</button>
    </div>

    <audio id="v-player"></audio><audio id="m-player" loop></audio>

    <script>
        // JS加密验证逻辑 (Waseda2026)
        const _0x51d2=["\x57\x61\x73\x65\x64\x61\x32\x30\x32\x36","\x76\x61\x6c\x75\x65","\x61\x75\x74\x68\x2d\x63\x6f\x64\x65","\x67\x65\x74\x45\x6c\x65\x6d\x65\x6e\x74\x42\x79\x49\x64","\x64\x69\x73\x70\x6c\x61\x79","\x73\x74\x79\x6c\x65","\x65\x6e\x74\x72\x79\x2d\x6d\x61\x73\x6b","\x6e\x6f\x6e\x65","\x73\x65\x6c\x65\x63\x74\x69\x6f\x6e\x2d\x75\x69","\x62\x6c\x6f\x63\x6b"];function _0x5a21(){const _0x3e12=document[_0x51d2[3]](_0x51d2[2])[_0x51d2[1]];if(_0x3e12===_0x51d2[0]){document[_0x51d2[3]](_0x51d2[6])[_0x51d2[5]][_0x51d2[4]]=_0x51d2[7];document[_0x51d2[3]](_0x51d2[8])[_0x51d2[5]][_0x51d2[4]]=_0x51d2[9];initCarousel();const mp=document.getElementById('m-player');mp.src='../bgm_1.mp3';mp.volume=0.2;mp.play().catch(e=>{});}else{alert("\x41\x43\x43\x45\x53\x53\x20\x44\x45\x4e\x49\x45\x44");}}

        // 核心逻辑
        let st = { 
            man: '', mode: '', active: false, 
            time: 1500, // 剩余秒数
            endTime: 0, // 关键修复：目标结束时间戳
            curIdx: 0, touchX: 0, timerInterval: null 
        };

        const datingData = {
            'chi': { title: '迟砚：惩戒阈值', story: '“看来平时的特训还是太仁慈了，才让你有胆量在我的眼皮底下，反复试探我的底线。”\n\n他面无表情地用牙齿扯下手套的一角，目光钉在你的脸上。\n\n“既然这么喜欢走神……接下来的惩罚，我们换一种更‘近’的方式。手给我，不许发抖。”', img: '../chi_reward.png' },
            'lin': { title: '林深：沦陷奖励', story: '“嘘……别动。现在，是只属于你一个人的‘奖励时间’。”\n\n他抵在唇边的指尖带着一丝微温，琥珀色的眼眸里溺满了令人心碎的温柔。\n\n“这一个月，辛苦了。过来……到我怀里来。让我听听，这颗属于我的心，跳得有多快？”', img: '../lin_reward.png' }
        };

        function initCarousel() {
            const el = document.getElementById('selection-ui');
            const inner = document.getElementById('carousel');
            el.addEventListener('touchstart', e => st.touchX = e.touches[0].clientX);
            el.addEventListener('touchend', e => {
                const diff = st.touchX - e.changedTouches[0].clientX;
                if (Math.abs(diff) > 60) {
                    st.curIdx = diff > 0 ? Math.min(st.curIdx + 1, 1) : Math.max(st.curIdx - 1, 0);
                    inner.style.transform = `translateX(-${st.curIdx * 100}%)`;
                    if(window.navigator.vibrate) window.navigator.vibrate(15);
                }
            });
        }

        function openMode(m) {
            st.man = m;
            const vp = document.getElementById('v-player');
            vp.src = `../${m}_select.wav`; vp.play();
            document.getElementById('mode-modal').style.display = 'flex';
        }

        function launch(mode) {
            st.mode = mode;
            document.getElementById('mode-modal').style.display = 'none';
            document.getElementById('selection-ui').style.display = 'none';
            document.getElementById('focus-mode').style.display = 'block';
            document.getElementById('back-home').style.display = 'block';
            const v = document.getElementById('v-bg');
            v.style.display = 'block';
            v.src = `../${st.man == 'chi' ? 'shen' : 'lin'}_work.mp4`; v.play();
            renderStars();
        }

        // 计时器修复算法：基于系统时间戳对比
        function toggleTimer() {
            const btn = document.getElementById('ctrl-btn');
            st.active = !st.active;
            btn.innerText = st.active ? "CONCENTRATING..." : "RESUME";
            
            if(st.active) {
                // 记录这一刻的理论结束时间
                st.endTime = Date.now() + st.time * 1000;
                st.timerInterval = setInterval(() => {
                    // 核心修复逻辑：计算物理时间差距
                    const now = Date.now();
                    st.time = Math.max(0, Math.ceil((st.endTime - now) / 1000));
                    
                    updateTimerUI();
                    
                    if(st.time <= 0) {
                        clearInterval(st.timerInterval);
                        btn.innerText = "COMPLETED";
                        st.active = false;
                    }
                    if(Math.random() < 0.005) triggerCheck();
                }, 1000);
            } else {
                clearInterval(st.timerInterval);
            }
        }

        function triggerCheck() {
            const v = document.getElementById('v-bg');
            const old = v.src;
            v.src = `../${st.man == 'chi' ? 'shen' : 'lin'}_look.mp4`;
            v.loop = false; v.play();
            v.onended = () => { v.src = old; v.loop = true; v.play(); };
        }

        function showGallery() {
            const data = datingData[st.man];
            const count = parseInt(localStorage.getItem(`pc_v4_${st.man}_count`) || 0);
            document.getElementById('gallery-title').innerText = st.man==='chi'?'迟砚·秘密记录':'林深·秘密记录';
            document.getElementById('reward-img').src = data.img;
            document.getElementById('reward-title-text').innerText = data.title;
            document.getElementById('reward-story-text').innerText = data.story;
            const card = document.getElementById('reward-main');
            if(count >= 30) {
                card.classList.add('active');
                document.getElementById('lock-badge').style.display = 'none';
            } else {
                card.classList.remove('active');
                document.getElementById('lock-badge').style.display = 'block';
            }
            document.getElementById('gallery-overlay').style.display = 'flex';
        }

        function hideGallery() { document.getElementById('gallery-overlay').style.display = 'none'; }

        function doSign() {
            const d = new Date().toDateString();
            const key = `pc_v4_${st.man}_sign`;
            if(localStorage.getItem(key) === d) { alert("今日已特训签到。"); return; }
            let c = parseInt(localStorage.getItem(`pc_v4_${st.man}_count`) || 0) + 1;
            localStorage.setItem(`pc_v4_${st.man}_count`, c);
            localStorage.setItem(key, d);
            renderStars();
            alert("同步成功。");
        }

        function renderStars() {
            const c = parseInt(localStorage.getItem(`pc_v4_${st.man}_count`) || 0);
            const g = document.getElementById('star-g');
            g.innerHTML = '';
            for(let i=0; i<30; i++) g.innerHTML += `<div class="star ${i < c ? 'active' : ''}">✦</div>`;
        }

        function updateTimerUI() {
            const m = Math.floor(st.time / 60);
            const s = (st.time % 60).toString().padStart(2, '0');
            document.getElementById('timer').innerText = `${m}:${s}`;
        }

        function backToHall() {
            st.active = false; clearInterval(st.timerInterval);
            document.getElementById('focus-mode').style.display = 'none';
            document.getElementById('back-home').style.display = 'none';
            document.getElementById('selection-ui').style.display = 'block';
            document.getElementById('v-bg').pause();
        }

        function tryFullScreen() {
            const doc = window.document.documentElement;
            if(doc.requestFullscreen) doc.requestFullscreen();
            else if(doc.webkitRequestFullScreen) doc.webkitRequestFullScreen();
        }
    </script>
</body>
</html>
