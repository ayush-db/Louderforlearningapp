export interface Grant {
  id: string;
  funder: string;
  title: string;
  tags: string[];
  specialTag?: string;
  amount: string;
  amountNum: number;
  deadline: string;
  match: number;
  isSpecialNeeds: boolean;
  applicants: number;
  description: string;
  eligibility: string[];
  requiredDocs: { name: string; type: string }[];
  avgCompletionMins: number;
}

export const grants: Grant[] = [
  {
    id: '1',
    funder: 'The Discovery Foundation',
    title: 'Interactive Science Kits for Grade 3',
    tags: ['STEM', 'Elementary'],
    amount: '$3,500',
    amountNum: 3500,
    deadline: 'Nov 15, 2024',
    match: 99,
    isSpecialNeeds: false,
    applicants: 14,
    description:
      'Provides funding for elementary classrooms to purchase hands-on STEM kits, supporting active inquiry and sensory-based scientific investigation for underfunded public school classrooms.',
    eligibility: [
      'Must be a full-time certified K–5 educator',
      'School must have >50% free/reduced lunch program rate',
      'STEM curricula integration must be clearly detailed',
    ],
    requiredDocs: [
      { name: 'Classroom Budget Proposal', type: 'PDF Template' },
      { name: 'Principal Approval Sign-off', type: 'Required' },
    ],
    avgCompletionMins: 12,
  },
  {
    id: '2',
    funder: 'Readers First Fund',
    title: 'Early Literacy & Phonics Classroom Library',
    tags: ['Reading', 'Elementary'],
    amount: '$2,000',
    amountNum: 2000,
    deadline: 'Nov 22, 2024',
    match: 94,
    isSpecialNeeds: false,
    applicants: 8,
    description:
      'Supports K–3 teachers in building diverse, culturally responsive classroom libraries that promote phonics literacy and independent reading skills in under-resourced schools.',
    eligibility: [
      'Must be a full-time K–3 classroom teacher',
      'School must qualify for Title I funding',
      'Classroom library plan must be submitted with application',
    ],
    requiredDocs: [
      { name: 'Book List & Reading Plan', type: 'PDF' },
      { name: 'Title I Certification', type: 'Required' },
    ],
    avgCompletionMins: 10,
  },
  {
    id: '3',
    funder: 'Focus & Flourish Org',
    title: 'Sensory Regulation Corner Equipments',
    tags: ['Special Education', 'All Levels'],
    specialTag: 'Special Needs',
    amount: '$1,500',
    amountNum: 1500,
    deadline: 'Dec 01, 2024',
    match: 97,
    isSpecialNeeds: true,
    applicants: 21,
    description:
      'Funds sensory-friendly classroom corners with fidget tools, lighting adjustments, noise-canceling headphones, and calm-down kits for students with autism spectrum disorder and ADHD.',
    eligibility: [
      'Must serve students with documented sensory processing needs',
      'School psychologist or SpEd coordinator must co-sign',
      'IEP documentation required for at least 30% of students',
    ],
    requiredDocs: [
      { name: 'Student Needs Summary', type: 'PDF' },
      { name: 'SpEd Coordinator Sign-off', type: 'Required' },
    ],
    avgCompletionMins: 15,
  },
  {
    id: '4',
    funder: 'IncludeAll Foundation',
    title: 'Adaptive Learning Tools for Neurodiverse Students',
    tags: ['Special Education', 'Elementary'],
    specialTag: 'Special Needs',
    amount: '$4,800',
    amountNum: 4800,
    deadline: 'Dec 10, 2024',
    match: 92,
    isSpecialNeeds: true,
    applicants: 6,
    description:
      'Provides assistive technology, adaptive software licenses, and differentiated learning materials for teachers supporting neurodiverse learners in inclusive classroom settings.',
    eligibility: [
      'Must teach in an inclusive or self-contained SpEd setting',
      'School must have <60% proficiency on state assessments',
      'Technology plan must align with district AT policy',
    ],
    requiredDocs: [
      { name: 'AT Needs Assessment', type: 'PDF' },
      { name: 'District Technology Policy Acknowledgment', type: 'Required' },
    ],
    avgCompletionMins: 18,
  },
  {
    id: '5',
    funder: 'Arts Flourish Fund',
    title: 'Creative Expression Classroom Grant',
    tags: ['Arts', 'Middle School'],
    amount: '$2,200',
    amountNum: 2200,
    deadline: 'Dec 20, 2024',
    match: 88,
    isSpecialNeeds: false,
    applicants: 11,
    description:
      'Supports middle school arts programs with supplies, equipment, and community partnerships to ensure every student has access to high-quality visual and performing arts education.',
    eligibility: [
      'Must be a certified arts educator in grades 6–8',
      'School must demonstrate need through FRPL data',
      'Project plan must include at least one community partner',
    ],
    requiredDocs: [
      { name: 'Arts Project Plan', type: 'PDF' },
      { name: 'Community Partner Letter', type: 'Required' },
    ],
    avgCompletionMins: 14,
  },
];
