(() => {
  const projects = window.PORTFOLIO_PROJECTS || [];
  const byId = new Map(projects.map(project => [project.id, project]));
  const featured = ['sukuk-capital', 'retaildesk', 'dispatch-ops'];
  const pageSize = 9;
  const categories = ['All', 'Mobile', 'Web', 'Backend', 'AI & Data', 'Design'];
  const categoriesWithPortraits = new Set(['sukuk-capital', 'entertainment', 'quit-must', 'bespokely']);
  const shapes = {
    Mobile: '<rect x="10" y="3" width="12" height="26" rx="3"/><path d="M13 7h6m-5 18h4"/>',
    Web: '<rect x="3" y="6" width="26" height="20" rx="2"/><path d="M3 12h26m-18 4h5m-5 4h10"/>',
    Backend: '<rect x="5" y="4" width="22" height="8" rx="2"/><rect x="5" y="20" width="22" height="8" rx="2"/><path d="M16 12v8M9 8h2m-2 16h2m4 0h8M15 8h8"/>',
    'AI & Data': '<path d="M5 5v22h22M9 21l6-7 5 4 7-9"/><circle cx="15" cy="14" r="1.5"/><circle cx="20" cy="18" r="1.5"/><circle cx="27" cy="9" r="1.5"/>',
    Design: '<rect x="4" y="4" width="24" height="24" rx="3"/><path d="M4 12h24M13 12v16"/>'
  };

  const grid = document.querySelector('#project-grid');
  const search = document.querySelector('#project-search');
  const filters = document.querySelector('#project-filters');
  const count = document.querySelector('#project-count');
  const more = document.querySelector('#show-more');
  const empty = document.querySelector('#project-empty');
  const dialog = document.querySelector('#project-dialog');
  const motion = window.matchMedia('(prefers-reduced-motion: reduce)');
  let category = 'All';
  let limit = pageSize;
  let lastTrigger = null;

  function element(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text) node.textContent = text;
    return node;
  }

  function makeMedia(project, expanded = false) {
    const tone = project.category === 'AI & Data' ? 'data' : project.category;
    const box = element('div', `media media--${tone}`);
    const fallback = () => {
      box.classList.remove('media--phone');
      box.setAttribute('aria-hidden', 'true');
      box.innerHTML = `<svg class="media-icon" viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.3">${shapes[project.category]}</svg>`;
    };
    if (!project.image) {
      fallback();
      return box;
    }
    if (categoriesWithPortraits.has(project.id)) box.classList.add('media--phone');
    if (expanded) box.classList.add('is-expanded');
    const img = element('img');
    img.alt = project.alt;
    img.loading = expanded ? 'eager' : 'lazy';
    img.decoding = 'async';
    img.addEventListener('error', fallback, { once: true });
    img.src = project.image;
    box.append(img);
    return box;
  }

  function makeCard(project, highlight = false) {
    const card = element('article', `card${highlight ? ' featured-card reveal' : ''}`);
    const content = element('div', 'card-content');
    const metadata = element('p', 'card-meta', `${project.category} · ${project.status}`);
    const heading = element('h3');
    const button = element('button', 'card-trigger', project.title);
    button.type = 'button';
    button.setAttribute('aria-haspopup', 'dialog');
    button.addEventListener('click', () => openProject(project, button));
    heading.append(button);
    const prompt = element('span', 'card-action', 'View project');
    prompt.setAttribute('aria-hidden', 'true');
    content.append(metadata, heading, element('p', '', project.description), prompt);
    card.append(makeMedia(project), content);
    return card;
  }

  function renderProjects(expand = false) {
    const query = search.value.trim().toLowerCase();
    const matching = projects.filter(project => {
      const text = [project.title, project.category, project.status, project.description, ...project.stack].join(' ').toLowerCase();
      return (category === 'All' || category === project.category) && text.includes(query);
    });
    const previous = expand ? grid.children.length : 0;
    const visible = matching.slice(0, limit);
    const cards = visible.slice(previous).map(project => makeCard(project));
    if (expand) grid.append(...cards);
    else grid.replaceChildren(...cards);
    const total = matching.length;
    count.textContent = total === 1 ? '1 project' : `${total} projects`;
    empty.hidden = total > 0;
    more.hidden = total <= limit;
    more.textContent = `Show ${Math.min(pageSize, total - limit)} more projects`;
    if (expand) cards[0]?.querySelector('button').focus({ preventScroll: true });
  }

  function selectCategory(next, button) {
    category = next;
    limit = pageSize;
    for (const item of filters.children) item.setAttribute('aria-pressed', String(item === button));
    renderProjects();
  }

  function setProjectUrl(id) {
    const url = new URL(window.location.href);
    if (id) url.searchParams.set('project', id);
    else url.searchParams.delete('project');
    history.replaceState(null, '', url);
  }

  function openProject(project, trigger = null) {
    lastTrigger = trigger;
    dialog.querySelector('#dialog-category').textContent = `${project.category} · ${project.status}`;
    dialog.querySelector('#dialog-title').textContent = project.title;
    dialog.querySelector('#dialog-description').textContent = project.description;
    dialog.querySelector('#dialog-detail').textContent = project.detail;
    dialog.querySelector('#dialog-media').replaceChildren(...(project.image ? [makeMedia(project, true)] : []));
    dialog.querySelector('#dialog-stack').replaceChildren(...project.stack.map(item => element('li', '', item)));
    const links = project.links.map(({ label, url }, index) => {
      const link = element('a', `button ${index === 0 ? 'button-primary' : 'button-quiet'}`, label);
      link.href = url;
      link.target = '_blank';
      link.rel = 'noopener noreferrer';
      return link;
    });
    dialog.querySelector('#dialog-links').replaceChildren(...links);
    setProjectUrl(project.id);
    dialog.showModal();
    dialog.scrollTop = 0;
    document.body.classList.add('dialog-open');
  }

  dialog.querySelector('#dialog-close').addEventListener('click', () => dialog.close());
  dialog.addEventListener('click', event => {
    if (event.target !== dialog) return;
    const rect = dialog.getBoundingClientRect();
    const onBackdrop = event.clientX < rect.left || event.clientX > rect.right ||
      event.clientY < rect.top || event.clientY > rect.bottom;
    if (onBackdrop) dialog.close();
  });
  dialog.addEventListener('close', () => {
    document.body.classList.remove('dialog-open');
    setProjectUrl(null);
    lastTrigger?.focus({ preventScroll: true });
    lastTrigger = null;
  });

  if (projects.length) {
    const cards = featured.map(id => byId.get(id)).filter(Boolean).map(project => makeCard(project, true));
    document.querySelector('#featured-projects').replaceChildren(...cards);
    for (const name of categories) {
      const button = element('button', 'filter', name);
      button.type = 'button';
      button.setAttribute('aria-pressed', String(name === category));
      button.addEventListener('click', () => selectCategory(name, button));
      filters.append(button);
    }
    search.addEventListener('input', () => {
      limit = pageSize;
      renderProjects();
    });
    more.addEventListener('click', () => {
      limit += pageSize;
      renderProjects(true);
    });
    renderProjects();
    const linkedProject = byId.get(new URL(window.location.href).searchParams.get('project'));
    if (linkedProject) openProject(linkedProject);
  }

  if (!motion.matches && 'IntersectionObserver' in window) {
    const observer = new IntersectionObserver(entries => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        entry.target.classList.remove('pending');
        observer.unobserve(entry.target);
      }
    }, { threshold: 0.12 });
    for (const target of document.querySelectorAll('.reveal')) {
      target.classList.add('pending');
      observer.observe(target);
    }
  }
})();
