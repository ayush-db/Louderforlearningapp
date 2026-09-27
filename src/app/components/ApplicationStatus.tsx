import { Check, Clock, MessageSquare, ChevronRight } from 'lucide-react';
import { BottomNav, Tab } from './BottomNav';

const STEPS = [
  { id: 1, label: 'Applied' },
  { id: 2, label: 'Review' },
  { id: 3, label: 'Approved' },
  { id: 4, label: 'Funded' },
];

const MONTH_NAMES = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

function formatDate(d: Date) {
  return `${MONTH_NAMES[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
}

function offsetDays(n: number) {
  const d = new Date();
  d.setDate(d.getDate() + n);
  return d;
}

interface Props {
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

export function ApplicationStatus({ activeTab, onTabChange }: Props) {
  const currentStep = 2;

  const milestones = [
    {
      label: 'School Eligibility Checked',
      date: formatDate(offsetDays(-12)),
      detail: 'Passed Title 1 review',
      done: true,
    },
    {
      label: 'Principal Approval Form Verified',
      date: formatDate(offsetDays(-13)),
      detail: 'Verified digitally',
      done: true,
    },
    {
      label: 'Application Submitted Successfully',
      date: formatDate(offsetDays(-14)),
      detail: 'Submitted by Sarah Davis',
      done: true,
    },
  ];
  const estimatedCompletion = formatDate(offsetDays(3));

  return (
    <div className="flex flex-col h-full bg-gray-50">
      <div className="flex-1 overflow-y-auto pb-24">
        {/* Header */}
        <div className="bg-white px-5 pt-12 pb-5" style={{ borderBottom: '1px solid #F0F0F0' }}>
          <div className="flex items-center gap-3 mb-1">
            <div
              className="w-9 h-9 rounded-xl flex items-center justify-center"
              style={{ background: '#1B7A50' }}
            >
              <span style={{ color: '#fff', fontWeight: 800, fontSize: '17px', lineHeight: 1 }}>L</span>
            </div>
            <p style={{ fontSize: '16px', fontWeight: 700, color: '#111827' }}>My Application Status</p>
          </div>
        </div>

        <div className="px-5 py-5">
          {/* Status row */}
          <div className="flex items-center justify-between mb-6">
            <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF' }}>
              APPLICATION PROGRESS
            </p>
            <span
              className="px-3 py-1 rounded-full"
              style={{ fontSize: '12px', fontWeight: 600, background: '#EBF6F0', color: '#1B7A50' }}
            >
              In Review
            </span>
          </div>

          {/* Progress steps */}
          <div className="flex items-start gap-0 mb-6 relative">
            {/* Connector line */}
            <div
              className="absolute top-5 left-5 right-5 h-0.5"
              style={{ background: '#E5E7EB', zIndex: 0 }}
            />
            <div
              className="absolute top-5 h-0.5"
              style={{
                left: '20px',
                width: `${((currentStep - 1) / (STEPS.length - 1)) * 100}%`,
                background: '#1B7A50',
                zIndex: 1,
              }}
            />
            {STEPS.map(step => {
              const done = step.id < currentStep;
              const active = step.id === currentStep;
              return (
                <div key={step.id} className="flex-1 flex flex-col items-center relative z-10">
                  <div
                    className="w-10 h-10 rounded-full flex items-center justify-center mb-1.5"
                    style={{
                      background: done ? '#1B7A50' : active ? '#fff' : '#F3F4F6',
                      border: active ? '2.5px solid #1B7A50' : done ? 'none' : '2px solid #E5E7EB',
                    }}
                  >
                    {done ? (
                      <Check size={16} color="#fff" strokeWidth={3} />
                    ) : (
                      <span style={{ fontSize: '14px', fontWeight: 700, color: active ? '#1B7A50' : '#9CA3AF' }}>
                        {step.id}
                      </span>
                    )}
                  </div>
                  <span style={{ fontSize: '11px', fontWeight: active || done ? 600 : 400, color: active || done ? '#1B7A50' : '#9CA3AF' }}>
                    {step.label}
                  </span>
                </div>
              );
            })}
          </div>

          {/* Under review card */}
          <div
            className="p-4 rounded-2xl mb-6"
            style={{ background: '#EBF6F0', border: '1px solid #C8E6D4' }}
          >
            <div className="flex items-start gap-3 mb-3">
              <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ background: '#1B7A50' }}>
                <Clock size={15} color="#fff" />
              </div>
              <div>
                <p style={{ fontSize: '15px', fontWeight: 700, color: '#134F34' }}>Under Review by Committee</p>
                <p style={{ fontSize: '13px', color: '#4D9E72', lineHeight: 1.55, marginTop: '2px' }}>
                  Your grant proposal is currently being vetted by the local school district board panel. They are verifying the alignment with standard K-5 STEM outcomes.
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2 pt-3" style={{ borderTop: '1px solid #C8E6D4' }}>
              <Clock size={13} color="#4D9E72" />
              <p style={{ fontSize: '12px', color: '#4D9E72' }}>Estimated completion date: {estimatedCompletion}</p>
            </div>
          </div>

          {/* Milestones */}
          <div className="mb-6">
            <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280', marginBottom: '14px' }}>
              MILESTONES LOG
            </p>
            <div className="flex flex-col gap-4">
              {milestones.map((m, i) => (
                <div key={i} className="flex items-start gap-3">
                  <div className="flex flex-col items-center">
                    <div className="w-2.5 h-2.5 rounded-full mt-1.5" style={{ background: '#1B7A50', flexShrink: 0 }} />
                    {i < milestones.length - 1 && (
                      <div className="w-0.5 flex-1 mt-1" style={{ background: '#C8E6D4', minHeight: '24px' }} />
                    )}
                  </div>
                  <div className="flex-1 pb-2">
                    <p style={{ fontSize: '14px', fontWeight: 600, color: '#111827' }}>{m.label}</p>
                    <p style={{ fontSize: '12px', color: '#6B7280', marginTop: '2px' }}>
                      {m.date} • {m.detail}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Help card */}
          <div
            className="flex items-center gap-3 p-4 rounded-2xl"
            style={{ background: '#fff', border: '1px solid #E5E7EB' }}
          >
            <div className="w-9 h-9 rounded-xl flex items-center justify-center" style={{ background: '#F3F4F6' }}>
              <MessageSquare size={17} color="#6B7280" />
            </div>
            <div className="flex-1">
              <p style={{ fontSize: '14px', fontWeight: 600, color: '#111827' }}>Need Help or Changes?</p>
              <p style={{ fontSize: '12px', color: '#6B7280' }}>Contact your local coordinator</p>
            </div>
            <div className="flex items-center gap-1" style={{ color: '#1B7A50', fontWeight: 600, fontSize: '14px' }}>
              Chat <ChevronRight size={15} color="#1B7A50" />
            </div>
          </div>
        </div>
      </div>

      <BottomNav activeTab={activeTab} onTabChange={onTabChange} />
    </div>
  );
}
