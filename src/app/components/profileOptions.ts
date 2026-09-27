import { School, BookOpen, GraduationCap, Heart, Wrench, Calculator, FlaskConical, Palette, Landmark, Zap, Music, Monitor, Globe2, Languages } from 'lucide-react';

export const SCHOOL_LEVELS = [
  { id: 'elementary', label: 'Elementary', sub: 'Grades K–5', Icon: School },
  { id: 'middle', label: 'Middle School', sub: 'Grades 6–8', Icon: BookOpen },
  { id: 'high', label: 'High School', sub: 'Grades 9–12', Icon: GraduationCap },
  { id: 'special', label: 'Special Education', sub: 'All Grade Levels', Icon: Heart },
  { id: 'cte', label: 'Career & Technical', sub: 'Vocational / CTE', Icon: Wrench },
];

export const SCHOOL_LEVEL_LABELS: Record<string, string> = {
  elementary: 'Elementary (K–5)',
  middle: 'Middle School (6–8)',
  high: 'High School (9–12)',
  special: 'Special Education',
  cte: 'Career & Technical',
};

export const SUBJECT_OPTIONS = [
  { id: 'math', label: 'Math', Icon: Calculator },
  { id: 'science', label: 'Science', Icon: FlaskConical },
  { id: 'english', label: 'English', Icon: BookOpen },
  { id: 'arts', label: 'Arts', Icon: Palette },
  { id: 'history', label: 'History', Icon: Landmark },
  { id: 'physed', label: 'Physical Ed', Icon: Zap },
  { id: 'music', label: 'Music', Icon: Music },
  { id: 'technology', label: 'Technology', Icon: Monitor },
  { id: 'social', label: 'Social Studies', Icon: Globe2 },
  { id: 'foreign', label: 'Foreign Language', Icon: Languages },
];

export const SUBJECT_LABELS: Record<string, string> = Object.fromEntries(
  SUBJECT_OPTIONS.map(s => [s.id, s.label])
);
