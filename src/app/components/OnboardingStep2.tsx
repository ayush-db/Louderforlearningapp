import { Calculator, FlaskConical, BookOpen, Palette, Landmark, Zap, Music, Monitor, Globe2, Languages, ChevronLeft, Check, Target } from 'lucide-react';

const subjects = [
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

interface Props {
  selected: string[];
  onToggle: (subject: string) => void;
  onFinish: () => void;
  onBack: () => void;
}

export function OnboardingStep2({ selected, onToggle, onFinish, onBack }: Props) {
  return (
    <div className="flex flex-col h-full bg-white px-5 pt-14 pb-10 overflow-y-auto">
      {/* Header */}
      <div className="flex items-center gap-3 mb-12">
        <div
          className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0"
          style={{ background: '#1B7A50' }}
        >
          <span style={{ color: '#fff', fontWeight: 800, fontSize: '17px', lineHeight: 1 }}>L</span>
        </div>
        <span style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.12em', color: '#6B7280' }}>
          LOUDER FOR LEARNING
        </span>
        <div className="ml-auto flex gap-1.5">
          <div className="w-6 h-1.5 rounded-full" style={{ background: '#1B7A50', opacity: 0.45 }} />
          <div className="w-6 h-1.5 rounded-full" style={{ background: '#1B7A50' }} />
        </div>
      </div>

      <h1 className="text-gray-900 mb-3" style={{ fontSize: '27px', fontWeight: 700, lineHeight: 1.2 }}>
        What subjects do you teach?
      </h1>
      <p style={{ fontSize: '15px', color: '#6B7280', lineHeight: 1.6, marginBottom: '28px' }}>
        Select all that apply — this helps us match you with subject-specific and interdisciplinary grant programs.
      </p>

      <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.1em', color: '#6B7280', marginBottom: '14px' }}>
        SELECT YOUR SUBJECTS
      </p>

      <div className="flex flex-wrap gap-2.5">
        {subjects.map(({ id, label, Icon }) => {
          const active = selected.includes(id);
          return (
            <button
              key={id}
              onClick={() => onToggle(id)}
              className="flex items-center gap-2 px-4 py-2.5 rounded-full border-2 transition-all"
              style={{
                borderColor: active ? '#1B7A50' : '#E5E7EB',
                background: active ? '#1B7A50' : '#fff',
                color: active ? '#fff' : '#374151',
                fontWeight: 500,
                fontSize: '14px',
              }}
            >
              <Icon size={13} />
              {label}
              {active && <Check size={12} strokeWidth={3} />}
            </button>
          );
        })}
      </div>

      {selected.length > 0 && (
        <div
          className="mt-6 p-4 rounded-2xl flex items-center gap-3"
          style={{ background: '#EBF6F0' }}
        >
          <Target size={17} color="#1B7A50" style={{ flexShrink: 0 }} />
          <span style={{ fontSize: '13px', color: '#1B7A50', fontWeight: 500 }}>
            {selected.length} {selected.length === 1 ? 'subject' : 'subjects'} selected — we'll match you with the best grants.
          </span>
        </div>
      )}

      <div className="mt-auto pt-8 flex flex-col gap-3">
        <button
          onClick={onFinish}
          disabled={selected.length === 0}
          className="w-full py-4 rounded-2xl flex items-center justify-center gap-2 transition-all"
          style={{
            background: selected.length > 0 ? '#1B7A50' : '#E5E7EB',
            color: selected.length > 0 ? '#fff' : '#9CA3AF',
            fontWeight: 600,
            fontSize: '16px',
            cursor: selected.length > 0 ? 'pointer' : 'not-allowed',
          }}
        >
          See My Recommendations →
        </button>
        <button
          onClick={onBack}
          className="flex items-center justify-center gap-1 py-2"
          style={{ color: '#6B7280', fontSize: '14px' }}
        >
          <ChevronLeft size={15} />
          Back
        </button>
      </div>
    </div>
  );
}
