import { School, BookOpen, GraduationCap, Heart, Wrench, Check } from 'lucide-react';

const levels = [
  { id: 'elementary', label: 'Elementary', sub: 'Grades K–5', Icon: School },
  { id: 'middle', label: 'Middle School', sub: 'Grades 6–8', Icon: BookOpen },
  { id: 'high', label: 'High School', sub: 'Grades 9–12', Icon: GraduationCap },
  { id: 'special', label: 'Special Education', sub: 'All Grade Levels', Icon: Heart },
  { id: 'cte', label: 'Career & Technical', sub: 'Vocational / CTE', Icon: Wrench },
];

interface Props {
  selected: string;
  onSelect: (level: string) => void;
  onNext: () => void;
}

export function OnboardingStep1({ selected, onSelect, onNext }: Props) {
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
          <div className="w-6 h-1.5 rounded-full" style={{ background: '#1B7A50' }} />
          <div className="w-6 h-1.5 rounded-full" style={{ background: '#E5E7EB' }} />
        </div>
      </div>

      <h1 className="text-gray-900 mb-3" style={{ fontSize: '27px', fontWeight: 700, lineHeight: 1.2 }}>
        Let's find grants built for you.
      </h1>
      <p style={{ fontSize: '15px', color: '#6B7280', lineHeight: 1.6, marginBottom: '28px' }}>
        Tell us a bit about your classroom so we can surface the most relevant funding opportunities.
      </p>

      <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.1em', color: '#6B7280', marginBottom: '14px' }}>
        WHAT BEST DESCRIBES YOU?
      </p>

      <div className="flex flex-col gap-3">
        {levels.map(({ id, label, sub, Icon }) => {
          const active = selected === id;
          return (
            <button
              key={id}
              onClick={() => onSelect(id)}
              className="flex items-center gap-4 p-4 rounded-2xl border-2 text-left transition-all"
              style={{
                borderColor: active ? '#1B7A50' : '#E5E7EB',
                background: active ? '#EBF6F0' : '#fff',
              }}
            >
              <div
                className="w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0"
                style={{ background: active ? '#1B7A50' : '#F3F4F6' }}
              >
                <Icon size={19} color={active ? '#fff' : '#6B7280'} />
              </div>
              <div className="flex-1 min-w-0">
                <div style={{ fontWeight: 600, fontSize: '15px', color: active ? '#1B7A50' : '#111827' }}>
                  {label}
                </div>
                <div style={{ fontSize: '13px', color: '#6B7280', marginTop: '1px' }}>{sub}</div>
              </div>
              {active && (
                <div
                  className="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0"
                  style={{ background: '#1B7A50' }}
                >
                  <Check size={13} color="#fff" strokeWidth={3} />
                </div>
              )}
            </button>
          );
        })}
      </div>

      <div className="mt-auto pt-10">
        <button
          onClick={onNext}
          disabled={!selected}
          className="w-full py-4 rounded-2xl flex items-center justify-center gap-2 transition-all"
          style={{
            background: selected ? '#1B7A50' : '#E5E7EB',
            color: selected ? '#fff' : '#9CA3AF',
            fontWeight: 600,
            fontSize: '16px',
            cursor: selected ? 'pointer' : 'not-allowed',
          }}
        >
          Next: Choose Subjects →
        </button>
        <p className="text-center mt-3" style={{ fontSize: '12px', color: '#9CA3AF' }}>
          Step 1 of 2 — takes less than a minute
        </p>
      </div>
    </div>
  );
}
