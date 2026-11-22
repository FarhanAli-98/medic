(() => {
  const FLIGHT_SECONDS = 2.65;
  const NEAR = 0.17;
  const FAR = 1.16;
  const PREFERENCE_KEY = 'portfolio-motion';
  const COLORS = ['#b5d5f1', '#87b9ee', '#71cde4', '#e6edf9', '#ddd2c9'];

  const random = (min, max) => min + Math.random() * (max - min);
  const clamp = (value, min, max) => Math.min(max, Math.max(min, value));
  const smoothstep = (value) => {
    const t = clamp(value, 0, 1);
    return t * t * (3 - 2 * t);
  };

  function initialize() {
    const canvas = document.querySelector('#starfield');
    if (!canvas) return;
    const context = canvas.getContext('2d', { alpha: true });
    const root = document.documentElement;
    const toggle = document.querySelector('#motion-toggle');
    const label = document.querySelector('#motion-label');
    const dialog = document.querySelector('#project-dialog');
    const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
    const coarse = window.matchMedia('(pointer: coarse)');
    const stars = [];
    const parallax = { x: 0, y: 0, scroll: 0, targetX: 0, targetY: 0, targetScroll: 0 };
    const lastVariables = {};
    let wantsPause = false;
    let reducedOverride = false;
    let running = false;
    let frame = null;
    let previousTime = null;
    let width = 1;
    let height = 1;
    let compact = false;
    let elapsed = 0;
    let nextMeteor = random(5.8, 9.2);
    let meteor = null;

    try {
      wantsPause = localStorage.getItem(PREFERENCE_KEY) === 'paused';
    } catch {
      // Local storage can be unavailable when site storage is disabled.
    }
    if (wantsPause || reduced.matches) elapsed = FLIGHT_SECONDS;

    function stillRequested() {
      return wantsPause || (reduced.matches && !reducedOverride);
    }

    function updateMotion() {
      const paused = stillRequested();
      if (paused) {
        root.dataset.motion = 'paused';
        elapsed = Math.max(elapsed, FLIGHT_SECONDS);
        meteor = null;
        parallax.x = parallax.y = parallax.scroll = 0;
        clearPointer();
        writeParallax();
      } else {
        root.dataset.motion = 'running';
        updateScrollTarget();
      }
      if (toggle) toggle.setAttribute('aria-pressed', String(paused));
      if (label) label.textContent = paused ? 'Resume motion' : 'Pause motion';
      syncAnimation();
    }

    function toggleMotion() {
      const paused = stillRequested();
      wantsPause = !paused;
      reducedOverride = paused && reduced.matches;
      try {
        if (wantsPause) localStorage.setItem(PREFERENCE_KEY, 'paused');
        else localStorage.removeItem(PREFERENCE_KEY);
      } catch {
        // The control still works for this page when settings cannot be saved.
      }
      updateMotion();
    }

    function placeStar(star, initial) {
      star.z = initial ? random(NEAR + 0.09, FAR) : FAR;
      if (star.dust && Math.random() < 0.57) {
        // A loose diagonal band adds depth without competing with the page.
        const x = random(-1.15, 1.15);
        star.x = x * star.z;
        star.y = (0.33 * x + random(-0.56, 0.56) + random(-0.25, 0.25)) * star.z;
      } else {
        star.x = random(-1.14, 1.14) * star.z;
        star.y = random(-1.14, 1.14) * star.z;
      }
    }

    function makeStar() {
      const layer = Math.random();
      const star = {
        dust: layer < 0.54,
        bright: layer > 0.965,
        size: layer < 0.54 ? random(0.27, 0.61) : random(0.44, 1.02),
        light: layer < 0.54 ? random(0.20, 0.49) : random(0.36, 0.79),
        velocity: layer < 0.54 ? random(0.45, 0.66) : random(0.78, 1.14),
        phase: random(0, Math.PI * 2),
        frequency: random(0.43, 1.32),
        color: COLORS[Math.floor(random(0, COLORS.length))],
      };
      placeStar(star, true);
      return star;
    }

    function resize() {
      const bounds = canvas.getBoundingClientRect();
      width = Math.max(1, bounds.width || window.innerWidth);
      height = Math.max(1, bounds.height || window.innerHeight);
      compact = coarse.matches || width < 720;
      if (context) {
        const area = width * height;
        const dpr = Math.min(window.devicePixelRatio || 1, compact ? 1.3 : 1.65, Math.sqrt(3000000 / area));
        canvas.width = Math.max(1, Math.round(width * dpr));
        canvas.height = Math.max(1, Math.round(height * dpr));
        context.setTransform(canvas.width / width, 0, 0, canvas.height / height, 0, 0);
        const count = Math.round(compact ? clamp(area / 1650, 170, 420) : clamp(area / 2250, 330, 950));
        if (stars.length > count) stars.length = count;
        while (stars.length < count) stars.push(makeStar());
      }
      meteor = null;
      paint(0);
    }

    function updateScrollTarget() {
      parallax.targetScroll = clamp((window.scrollY || 0) * 0.063, 0, 32);
    }

    function updatePointer(event) {
      if (!running || event.isPrimary === false) return;
      const range = event.pointerType === 'touch' || compact ? 7 : 16;
      parallax.targetX = clamp(event.clientX / width * 2 - 1, -1, 1) * range;
      parallax.targetY = clamp(event.clientY / height * 2 - 1, -1, 1) * range;
    }

    function clearPointer() {
      parallax.targetX = 0;
      parallax.targetY = 0;
    }

    function writeParallax() {
      for (const name of ['x', 'y', 'scroll']) {
        const value = Math.round(parallax[name] * 5) / 5;
        if (lastVariables[name] === value) continue;
        root.style.setProperty(`--space-${name}`, `${value}px`);
        lastVariables[name] = value;
      }
    }

    function scheduleMeteor() {
      nextMeteor = elapsed + (compact ? random(15, 29) : random(11, 23));
      const direction = Math.random() > 0.28 ? -1 : 1;
      meteor = {
        start: elapsed,
        duration: random(1.22, 1.68),
        x: direction === -1 ? random(width * 0.52, width * 0.95) : random(width * 0.05, width * 0.45),
        y: random(height * 0.075, height * 0.38),
        dx: direction * random(width * 0.14, width * 0.31),
        dy: random(height * 0.075, height * 0.15),
      };
    }

    function paintMeteor() {
      const progress = (elapsed - meteor.start) / meteor.duration;
      if (progress >= 1) {
        meteor = null;
        return;
      }
      const { x, y, dx, dy } = meteor;
      const opacity = smoothstep(progress / 0.22) * smoothstep((1 - progress) / 0.36);
      if (opacity <= 0) return;
      const headX = x + progress * dx;
      const headY = y + progress * dy;
      const tailLength = Math.min(progress, compact ? 0.32 : 0.40);
      const tailX = headX - dx * tailLength;
      const tailY = headY - dy * tailLength;
      const gradient = context.createLinearGradient(tailX, tailY, headX, headY);
      gradient.addColorStop(0, 'rgba(84, 188, 230, 0)');
      gradient.addColorStop(0.64, 'rgba(92, 210, 248, 0.21)');
      gradient.addColorStop(1, 'rgba(175, 241, 255, 0.8)');
      context.globalAlpha = opacity;
      context.strokeStyle = gradient;
      context.lineWidth = compact ? 0.8 : 1.2;
      context.beginPath();
      context.moveTo(tailX, tailY);
      context.lineTo(headX, headY);
      context.stroke();
      context.globalAlpha = opacity * 0.76;
      context.fillStyle = '#d7f8ff';
      context.fillRect(headX - 0.7, headY - 0.7, 1.4, 1.4);
    }

    function paintStar(star, delta, flight, driftX, driftY) {
      if (delta > 0) {
        star.z -= delta * (0.014 + flight * 0.68) * star.velocity;
        if (star.z < NEAR) placeStar(star, false);
      }
      const { z } = star;
      const relativeX = star.x / z;
      const relativeY = star.y / z;
      const extent = Math.max(Math.abs(relativeX), Math.abs(relativeY));
      if (extent > 1.21) {
        if (delta > 0) placeStar(star, false);
        return;
      }
      const depth = clamp((FAR - z) / (FAR - NEAR), 0, 1);
      const halfWidth = width * 0.5;
      const halfHeight = height * 0.5;
      const pull = 0.34 + depth * 0.92;
      const x = (1 + relativeX) * halfWidth + driftX * pull;
      const y = (1 + relativeY) * halfHeight + driftY * pull;
      const twinkle = 0.91 + 0.09 * Math.sin(elapsed * star.frequency + star.phase);
      const birth = smoothstep((FAR - z) / 0.16);
      const edgeFade = smoothstep((1.18 - extent) / 0.16);
      const nearFade = smoothstep((z - NEAR) / 0.12);
      const light = Math.min(0.85, star.light * (0.57 + depth * 0.71) * twinkle * birth * edgeFade * nearFade);
      if (light < 0.025) return;
      const radius = star.size * (0.74 + depth * 0.66) * (star.bright ? 1.18 : 1);

      if (flight > 0.16 && !star.dust) {
        const trailFactor = 1 - z / (z + flight * 0.082);
        const dx = relativeX * halfWidth * trailFactor;
        const dy = relativeY * halfHeight * trailFactor;
        const distance = Math.hypot(dx, dy);
        if (distance > 2.2) {
          const cap = Math.min(1, (compact ? 25 : 46) / distance);
          context.globalAlpha = light * flight * 0.50;
          context.strokeStyle = star.color;
          context.lineWidth = Math.min(1.35, radius * 1.3);
          context.beginPath();
          context.moveTo(x - dx * cap, y - dy * cap);
          context.lineTo(x, y);
          context.stroke();
        }
      }

      context.fillStyle = star.color;
      if (star.bright) {
        context.globalAlpha = light * 0.14;
        context.beginPath();
        context.arc(x, y, radius * 2.5, 0, Math.PI * 2);
        context.fill();
      }
      context.globalAlpha = light;
      if (radius > 0.66) {
        context.beginPath();
        context.arc(x, y, radius, 0, Math.PI * 2);
        context.fill();
      } else {
        context.fillRect(x - radius, y - radius, radius * 2, radius * 2);
      }
    }

    function paint(delta) {
      if (!context) return;
      context.globalAlpha = 1;
      context.clearRect(0, 0, width, height);
      const flight = delta > 0 && elapsed < FLIGHT_SECONDS
        ? smoothstep(elapsed / 0.26) * (1 - smoothstep((elapsed - 0.24) / (FLIGHT_SECONDS - 0.24)))
        : 0;
      const driftX = Math.sin(elapsed * 0.16) * 5.5 - parallax.x;
      const driftY = Math.cos(elapsed * 0.11) * 3.5 - parallax.y - parallax.scroll * 0.74;
      for (const star of stars) paintStar(star, delta, flight, driftX, driftY);
      if (delta > 0 && elapsed >= nextMeteor && !meteor) scheduleMeteor();
      if (meteor && delta > 0) paintMeteor();
      context.globalAlpha = 1;
    }

    function tick(now) {
      frame = null;
      if (!running) return;
      const interval = 1000 / (elapsed < FLIGHT_SECONDS && !compact ? 60 : compact ? 30 : 44);
      if (previousTime === null) previousTime = now - interval;
      const span = now - previousTime;
      if (span >= interval - 1) {
        const delta = Math.min(span / 1000, 0.065);
        previousTime = now;
        elapsed += delta;
        const follow = 1 - Math.exp(-delta * 5);
        parallax.x += (parallax.targetX - parallax.x) * follow;
        parallax.y += (parallax.targetY - parallax.y) * follow;
        parallax.scroll += (parallax.targetScroll - parallax.scroll) * follow;
        writeParallax();
        paint(delta);
      }
      frame = window.requestAnimationFrame(tick);
    }

    function syncAnimation() {
      const canMove = !stillRequested() && !document.hidden && !dialog?.open;
      if (canMove === running) {
        if (!canMove && !document.hidden) paint(0);
        return;
      }
      running = canMove;
      previousTime = null;
      if (running) {
        frame = window.requestAnimationFrame(tick);
      } else {
        if (frame !== null) window.cancelAnimationFrame(frame);
        frame = null;
        clearPointer();
        if (!document.hidden) paint(0);
      }
    }

    const passive = { passive: true };
    root.addEventListener('pointerleave', clearPointer, passive);
    window.addEventListener('pointermove', updatePointer, passive);
    window.addEventListener('pointercancel', clearPointer, passive);
    window.addEventListener('pointerup', event => {
      if (event.pointerType === 'touch') clearPointer();
    }, passive);
    window.addEventListener('blur', clearPointer);
    window.addEventListener('scroll', updateScrollTarget, passive);
    window.addEventListener('resize', resize, passive);
    document.addEventListener('visibilitychange', syncAnimation);
    const preferenceChanged = () => {
      reducedOverride = false;
      updateMotion();
    };
    if ('addEventListener' in reduced) {
      reduced.addEventListener('change', preferenceChanged);
      coarse.addEventListener('change', resize);
    } else {
      reduced.addListener(preferenceChanged);
      coarse.addListener(resize);
    }
    if (dialog && 'MutationObserver' in window) {
      new MutationObserver(syncAnimation).observe(dialog, { attributes: true, attributeFilter: ['open'] });
    }
    if (toggle) {
      toggle.hidden = false;
      toggle.addEventListener('click', toggleMotion);
    }
    resize();
    writeParallax();
    updateMotion();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initialize, { once: true });
  } else {
    initialize();
  }
})();
