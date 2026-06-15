import { ChevronLeft, Check, FileText, Clock, Users, DollarSign } from 'lucide-react';
import { grants } from './grantData';

interface Props {
  grantId: string;
  onBack: () => void;
  onApply: (grantId: string) => void;
}

export function GrantDetails({ grantId, onBack, onApply }: Props) {
  const grant = grants.find(g => g.id === grantId) ?? grants[0];

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Header */}
      <div className="px-5 pt-12 pb-5 bg-white" style={{ borderBottom: '1px solid #F0F0F0' }}>
        <div className="flex items-center gap-3 mb-5">
          <button
            onClick={onBack}
            className="w-9 h-9 rounded-full flex items-center justify-center"
            style={{ background: '#F3F4F6' }}
          >
            <ChevronLeft size={20} color="#374151" />
          </button>
          <p style={{ fontSize: '16px', fontWeight: 700, color: '#111827' }}>Grant Details</p>
        </div>

        {/* Funder + match */}
        <div className="flex items-start justify-between gap-3">
          <div className="flex-1">
            <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#1B7A50' }}>
              {grant.funder.toUpperCase()}
            </p>
            <h1 className="text-gray-900 mt-1" style={{ fontSize: '22px', fontWeight: 700, lineHeight: 1.25 }}>
              {grant.title}
            </h1>
          </div>
          <div
            className="flex flex-col items-center justify-center rounded-full flex-shrink-0"
            style={{ width: 54, height: 54, background: '#134F34' }}
          >
            <span style={{ color: '#fff', fontWeight: 700, fontSize: '14px', lineHeight: 1 }}>{grant.match}%</span>
            <span style={{ color: '#A7D9BC', fontSize: '9px', lineHeight: 1.2 }}>Match</span>
          </div>
        </div>

        {/* Stats row */}
        <div
          className="flex mt-5 rounded-2xl overflow-hidden"
          style={{ background: '#F8FAFB', border: '1px solid #E5E7EB' }}
        >
          {[
            { label: 'FUNDING', value: grant.amount, Icon: DollarSign },
            { label: 'APPLICANTS', value: `${grant.applicants} Teachers`, Icon: Users },
            { label: 'DEADLINE', value: grant.deadline, Icon: Clock },
          ].map(({ label, value, Icon }, i) => (
            <div
              key={label}
              className="flex-1 py-3 px-2 flex flex-col items-center"
              style={{ borderLeft: i > 0 ? '1px solid #E5E7EB' : 'none' }}
            >
              <p style={{ fontSize: '9px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF' }}>{label}</p>
              <p style={{ fontSize: '13px', fontWeight: 700, color: '#111827', marginTop: '2px' }}>{value}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Scrollable body */}
      <div className="flex-1 overflow-y-auto px-5 py-5 pb-28">
        {/* Project Focus */}
        <section className="mb-6">
          <h2 className="text-gray-900 mb-3" style={{ fontSize: '14px', fontWeight: 700 }}>PROJECT FOCUS</h2>
          <p style={{ fontSize: '14px', color: '#374151', lineHeight: 1.65 }}>{grant.description}</p>
        </section>

        {/* Eligibility */}
        <section className="mb-6">
          <h2 className="text-gray-900 mb-3" style={{ fontSize: '14px', fontWeight: 700 }}>ELIGIBILITY REQUIREMENTS</h2>
          <div className="flex flex-col gap-3">
            {grant.eligibility.map((req, i) => (
              <div key={i} className="flex items-start gap-3">
                <div
                  className="w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5"
                  style={{ background: '#EBF6F0' }}
                >
                  <Check size={11} color="#1B7A50" strokeWidth={3} />
                </div>
                <p style={{ fontSize: '14px', color: '#374151', lineHeight: 1.5 }}>{req}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Required Docs */}
        <section className="mb-6">
          <h2 className="text-gray-900 mb-3" style={{ fontSize: '14px', fontWeight: 700 }}>REQUIRED DOCUMENTS</h2>
          <div className="flex flex-col gap-2">
            {grant.requiredDocs.map((doc, i) => (
              <div
                key={i}
                className="flex items-center gap-3 p-3.5 rounded-xl"
                style={{ background: '#F8FAFB', border: '1px solid #E5E7EB' }}
              >
                <FileText size={17} color="#6B7280" />
                <span style={{ flex: 1, fontSize: '14px', color: '#374151', fontWeight: 500 }}>{doc.name}</span>
                <span
                  className="px-2 py-0.5 rounded-full"
                  style={{ fontSize: '11px', color: '#6B7280', background: '#E5E7EB' }}
                >
                  {doc.type}
                </span>
              </div>
            ))}
          </div>
        </section>
      </div>

      {/* CTA */}
      <div
        className="px-5 py-4 bg-white"
        style={{ borderTop: '1px solid #F0F0F0' }}
      >
        <button
          onClick={() => onApply(grant.id)}
          className="w-full py-4 rounded-2xl flex items-center justify-center gap-2 transition-all active:scale-[0.98]"
          style={{ background: '#1B7A50', color: '#fff', fontWeight: 700, fontSize: '16px' }}
        >
          Begin Application →
        </button>
        <p className="text-center mt-2" style={{ fontSize: '12px', color: '#9CA3AF' }}>
          Average completion time: {grant.avgCompletionMins} minutes
        </p>
      </div>
    </div>
  );
}
