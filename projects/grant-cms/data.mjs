const neighborhood = {
  title: 'Neighborhood Spaces Fund',
  slug: 'neighborhood-spaces',
  category: 'Public spaces',
  summary: 'Small grants for resident-led improvements to shared spaces, from pocket gardens to accessible gathering areas.',
  opening: '2027-01-12',
  deadline: '2027-03-19',
  funding: '$2,000–$12,000',
  eligibility: 'Neighborhood groups and community nonprofits with a local delivery partner.',
  description: 'Tell us what you would improve, who would use it, and how your neighbors will help design and care for the space. Include a simple project budget and a proposed schedule.\n\nProjects should be achievable in six months and expand access to a shared space.'
};

const makers = {
  title: 'Community Makers Microgrants',
  slug: 'community-makers',
  category: 'Arts and culture',
  summary: 'Support for small, hands-on arts and repair projects led by local residents.',
  opening: '2027-02-08',
  deadline: '2027-04-20',
  funding: 'Up to $4,000',
  eligibility: 'Resident-led groups with a fiscal sponsor.',
  description: 'Propose a project that gives neighbors time, tools, or space to learn a practical skill together.'
};

const access = {
  title: 'Access to Learning',
  slug: 'access-to-learning',
  category: 'Education',
  summary: 'Funding for transport, translation, and adaptive equipment that help more people participate in community learning.',
  opening: '2027-01-25',
  deadline: '2027-04-05',
  funding: '$5,000–$18,000',
  eligibility: 'Registered nonprofits that deliver community education.',
  description: 'Describe the participation barrier, how people affected by it shaped your plan, and how you will measure improved access.'
};

export function initialState() {
  return {
    grants: [
      { id: 'spaces', draft: neighborhood, live: { ...neighborhood }, legacyPath: '/funding/neighbourhood-2024', redirects: [] },
      { id: 'makers', draft: makers, live: null, legacyPath: '', redirects: [] },
      { id: 'learning', draft: { ...access, eligibility: 'Registered nonprofits and public libraries that deliver community education.' }, live: { ...access }, legacyPath: '/funding/education-access', redirects: [] }
    ]
  };
}

export const sampleImport = [
  {
    "title": "Community Energy Pilot",
    "slug": "community-energy-pilot",
    "category": "Environment",
    "summary": "Support for neighborhood groups testing ways to reduce shared energy costs.",
    "opening": "2027-02-01",
    "deadline": "2027-04-30",
    "funding": "$3,000–$15,000",
    "eligibility": "Resident-led groups working with a registered nonprofit.",
    "description": "Share the problem you want to address and how you will test a practical solution with neighbors.",
    "legacyPath": "/funding/community-energy-2025"
  }
];
