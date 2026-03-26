class ReactionTimeGame {
    constructor() {
        this.gameArea = document.getElementById('gameArea');
        this.messageEl = document.getElementById('message');
        this.lastTimeEl = document.getElementById('lastTime');
        this.bestTimeEl = document.getElementById('bestTime');
        this.levelEl = document.getElementById('level');
        this.startBtn = document.getElementById('startBtn');
        this.levelBtn = document.getElementById('levelBtn');

        this.state = 'idle'; // idle, waiting, ready, done
        this.startTime = 0;
        this.lastTime = null;
        this.bestTime = localStorage.getItem('bestTime') ? parseInt(localStorage.getItem('bestTime')) : null;
        this.level = 'easy'; // easy, medium, hard
        this.delayRange = { easy: [2, 4], medium: [1, 3], hard: [0.5, 2] };
        this.isClickable = false;

        this.setupEventListeners();
        this.updateDisplay();
    }

    setupEventListeners() {
        this.startBtn.addEventListener('click', () => this.startGame());
        this.levelBtn.addEventListener('click', () => this.changeLevel());
        this.gameArea.addEventListener('click', () => this.handleGameAreaClick());
    }

    startGame() {
        if (this.state !== 'idle') return;
        
        this.state = 'waiting';
        this.isClickable = false;
        this.gameArea.classList.remove('ready', 'early', 'done');
        this.gameArea.classList.add('waiting');
        this.messageEl.textContent = '🔴 ATTENDEZ...';
        this.startBtn.disabled = true;

        const [minDelay, maxDelay] = this.delayRange[this.level];
        const delay = Math.random() * (maxDelay - minDelay) + minDelay;

        setTimeout(() => {
            this.goReady(delay * 1000);
        }, delay * 1000);
    }

    goReady(displayTime) {
        if (this.state !== 'waiting') return;

        this.state = 'ready';
        this.startTime = performance.now();
        this.isClickable = true;
        this.gameArea.classList.remove('waiting', 'early', 'done');
        this.gameArea.classList.add('ready');
        this.messageEl.textContent = '🟢 CLIQUEZ!';

        // Auto-fail after 5 seconds
        setTimeout(() => {
            if (this.state === 'ready') {
                this.endGame(5000, true);
            }
        }, 5000);
    }

    handleGameAreaClick() {
        if (!this.isClickable) {
            if (this.state === 'waiting') {
                this.endGame(0, false, 'TOO_EARLY');
            }
            return;
        }

        const reactionTime = performance.now() - this.startTime;
        this.endGame(reactionTime, true);
    }

    endGame(time, success, reason = null) {
        this.state = 'done';
        this.isClickable = false;
        this.startBtn.disabled = false;

        if (reason === 'TOO_EARLY') {
            this.gameArea.classList.add('early');
            this.messageEl.textContent = '⚠️ TROP TÔT! Réessayez...';
        } else if (!success) {
            this.gameArea.classList.add('done');
            this.messageEl.textContent = '😴 Trop lent! Réessayez...';
        } else {
            this.gameArea.classList.add('done');
            this.lastTime = Math.round(time);
            this.messageEl.textContent = `⚡ ${this.lastTime}ms`;

            if (this.bestTime === null || this.lastTime < this.bestTime) {
                this.bestTime = this.lastTime;
                localStorage.setItem('bestTime', this.bestTime);
            }

            this.updateDisplay();
        }

        setTimeout(() => {
            this.state = 'idle';
            this.gameArea.classList.remove('waiting', 'ready', 'early', 'done');
            this.messageEl.textContent = 'Cliquez pour commencer';
        }, 2000);
    }

    changeLevel() {
        const levels = ['easy', 'medium', 'hard'];
        const levelNames = ['Facile', 'Moyen', 'Difficile'];
        const currentIndex = levels.indexOf(this.level);
        const nextIndex = (currentIndex + 1) % levels.length;

        this.level = levels[nextIndex];
        this.levelEl.textContent = levelNames[nextIndex];
        this.levelBtn.textContent = `Niveau: ${levelNames[nextIndex]}`;
    }

    updateDisplay() {
        this.lastTimeEl.textContent = this.lastTime ? this.lastTime : '--';
        this.bestTimeEl.textContent = this.bestTime ? this.bestTime : '--';
    }
}

// Initialize game when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new ReactionTimeGame();
});
