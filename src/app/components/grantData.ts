export interface Grant {
  id: string;
  funder: string;
  title: string;
  tags: string[];
  specialTag?: string;
  amount: string;
  amountNum: number;
  deadline: string;
  applyUrl?: string;
  match?: number;
  isSpecialNeeds: boolean;
  applicants?: number;
  description: string;
  eligibility: string[];
  requiredDocs: { name: string; type: string }[];
  avgCompletionMins?: number;
}

export const grants: Grant[] = [
  {
    id: '1',
    funder: 'Fund for Teachers',
    title: 'Individual & Team Fellowship Grants',
    tags: ['All Subjects', 'Professional Development'],
    amount: '$5,000 (individual) / $10,000 (team)',
    amountNum: 10000,
    deadline: 'Opens Oct 1, 2026 (annual cycle)',
    applyUrl: 'https://fft.fundforteachers.org/signup',
    isSpecialNeeds: false,
    description:
      'Fund for Teachers awards self-designed summer fellowship grants so PreK-12 teachers can pursue the professional learning experience of their choice — travel, research, or coursework — then bring it back to their classroom.',
    eligibility: [
      'Full-time PreK-12 teacher, counselor, or librarian with direct, daily contact with students',
      'Must design your own learning experience (individually or as a team of 2+)',
      'Fellowship must take place during a school break, typically summer',
    ],
    requiredDocs: [
      { name: 'Fellowship Proposal Narrative', type: 'Required' },
      { name: 'Budget Worksheet', type: 'Required' },
    ],
  },
  {
    id: '2',
    funder: 'Association of American Educators (AAE) Foundation',
    title: 'National Teacher Scholarship & Classroom Grant',
    tags: ['All Subjects'],
    amount: '$500 scholarship + $500 classroom grant',
    amountNum: 1000,
    deadline: 'Oct 1 & Mar 1 (two cycles/year)',
    applyUrl: 'https://form.jotform.com/242053895486164',
    isSpecialNeeds: false,
    description:
      "Twice a year, the AAE Foundation awards a $500 professional development scholarship and a separate $500 classroom grant to full-time educators, drawn from eligible applicants who haven't received an AAE award in the past two years.",
    eligibility: [
      'Full-time educator in the United States',
      'Have not received an AAE Foundation scholarship or grant in the past two years',
      'Submit a brief statement on the planned use of funds',
    ],
    requiredDocs: [
      { name: 'Scholarship/Grant Application', type: 'Online Form' },
      { name: 'Statement of Intended Use', type: 'Required' },
    ],
  },
  {
    id: '3',
    funder: 'DonorsChoose',
    title: 'Classroom Project Crowdfunding',
    tags: ['Any Subject'],
    amount: 'Varies (crowdfunded)',
    amountNum: 0,
    deadline: 'Rolling — no deadline',
    applyUrl: 'https://secure.donorschoose.org/teacher/teacher_registration.html',
    isSpecialNeeds: false,
    description:
      'DonorsChoose lets public school teachers post a specific classroom project or supply request and have it funded directly by individual donors, matching campaigns, and corporate partners until it reaches its goal.',
    eligibility: [
      'Full-time teacher at a public or public charter school',
      'Project must be for use with your own students',
      'Funds are supply/vendor-fulfilled, not cash disbursed to the teacher',
    ],
    requiredDocs: [
      { name: 'Project Description & Materials List', type: 'Online Form' },
      { name: 'School Verification', type: 'Required' },
    ],
  },
  {
    id: '4',
    funder: 'NEA Foundation',
    title: 'Learning & Leadership Grants',
    tags: ['Professional Development'],
    amount: '$5,000',
    amountNum: 5000,
    deadline: 'Feb 1, Apr 28, or Sep 15 (three cycles/year)',
    applyUrl: 'https://www.nea.org/professional-excellence/professional-learning/resources',
    isSpecialNeeds: false,
    description:
      'Learning & Leadership Grants fund individual or group professional-learning experiences — summer institutes, conferences, action research, or study groups — that educators bring back to improve student learning.',
    eligibility: [
      'Current NEA member (teacher, ESP, or specialized instructional support professional)',
      'Not a current NEA Foundation grantee',
      'Activity must be completed within 12 months of the award',
    ],
    requiredDocs: [
      { name: 'Grant Application', type: 'Online Form' },
      { name: 'Professional Learning Plan', type: 'Required' },
    ],
  },
  {
    id: '5',
    funder: 'McCarthey Dressman Education Foundation',
    title: 'Academic Enrichment & Teacher Development Grants',
    tags: ['General Classroom', 'K-12'],
    amount: '$10,000/year',
    amountNum: 10000,
    deadline: 'Jan 15 – Apr 15 (closes early at 200 submissions)',
    applyUrl: 'https://mccartheydressman.org/teacher-development-grants/',
    isSpecialNeeds: false,
    description:
      'MDEF funds K-12 educator-led projects that improve student learning, awarding up to $10,000 per year (renewable to $20,000 over two years) through its Academic Enrichment and Teacher Development grant tracks.',
    eligibility: [
      'Licensed K-12 teacher, or educator with direct regular contact with PreK-12 students',
      'Project serves students from low-income households',
      'Willing to collaborate with the Foundation on reporting',
    ],
    requiredDocs: [
      { name: 'Project Proposal', type: 'Online Form' },
      { name: 'Budget Narrative', type: 'Required' },
    ],
  },
  {
    id: '6',
    funder: 'U.S. Department of Energy / AEF Program',
    title: 'Albert Einstein Distinguished Educator Fellowship',
    tags: ['STEM'],
    amount: 'Paid DC fellowship stipend (no classroom payment)',
    amountNum: 0,
    deadline: 'Nov 13 (annual)',
    applyUrl: 'https://science.osti.gov/wdts/einstein',
    isSpecialNeeds: false,
    description:
      'A federally sponsored fellowship, not a classroom grant: accomplished K-12 STEM teachers spend eleven months working in a federal agency or Congressional office on national education policy, then return to the classroom with that experience.',
    eligibility: [
      'Full-time STEM teacher for at least 5 of the last 7 years',
      'Able to take an 11-month leave of absence from teaching',
      'Three letters of recommendation, including one from a district official',
      'Maximum of 3 applications within a 6-year period',
    ],
    requiredDocs: [
      { name: 'Letters of Recommendation (3)', type: 'Required' },
      { name: 'Personal Statement', type: 'Required' },
    ],
  },
  {
    id: '7',
    funder: 'National Science Foundation',
    title: 'Discovery Research PreK-12 (DRK-12)',
    tags: ['STEM'],
    amount: 'Institutional research award (no individual payment)',
    amountNum: 0,
    deadline: 'Varies by year — check current NSF solicitation',
    applyUrl: 'https://new.nsf.gov/funding/opportunities/discovery-research-prek-12-drk-12',
    isSpecialNeeds: false,
    description:
      'DRK-12 funds research and development of STEM education innovations for PreK-12 settings. Proposals are submitted through an institution (university, district, or nonprofit); classroom teachers typically participate as project partners or co-PIs rather than as direct grant recipients.',
    eligibility: [
      'Proposal submitted through an eligible institution (IHE, school district, or nonprofit)',
      'Teachers participate as partners, advisors, or co-PIs rather than sole applicants',
      'Project must address a STEM education research question at the PreK-12 level',
    ],
    requiredDocs: [
      { name: 'Full Research Proposal (via sponsoring institution)', type: 'Required' },
      { name: 'Letters of Collaboration', type: 'Required' },
    ],
  },
];
