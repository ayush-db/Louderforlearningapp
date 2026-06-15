import { useState } from 'react';
import { ChevronLeft, Check, Upload, Trash2, AlertCircle, FileText } from 'lucide-react';
import { grants } from './grantData';

interface Props {
  grantId: string;
  onBack: () => void;
  onSubmit: () => void;
}

type Step = 1 | 2 | 3;

const MAX_WORDS = 500;
function wordCount(text: string) {
  return text.trim() ? text.trim().split(/\s+/).length : 0;
}

export function ApplicationForm({ grantId, onBack, onSubmit }: Props) {
  const grant = grants.find(g => g.id === grantId) ?? grants[0];

  const [step, setStep] = useState<Step>(2); // Start on step 2 per design
  const [projectName, setProjectName] = useState('Hands-on Elementary STEM Labs');
  const [fundingAmt, setFundingAmt] = useState('$3,500');
  const [description, setDescription] = useState(
    'This grant will fund classroom-wide reusable chemistry and physics kits for our 45 third-grade students. Most of our students come from families below the poverty line, and interactive labs will inspire a strong foundational STEM path.'
  );
  const [uploadedDocs, setUploadedDocs] = useState<string[]>(['Classroom_Budget_Proposal.pdf']);
  const [certified, setCertified] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const words = wordCount(description);
  const overLimit = words > MAX_WORDS;

  function handleRemoveDoc(name: string) {
    setUploadedDocs(d => d.filter(x => x !== name));
  }

  function handleUpload() {
    setUploadedDocs(d => [...d, 'Principal_Approval_Form.pdf']);
  }

  function handleSubmit() {
    if (!certified || overLimit) return;
    setSubmitted(true);
    setTimeout(onSubmit, 800);
  }

  const stepLabels = ['Basic Info', 'Your Project', 'Review'];

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Header */}
      <div className="px-5 pt-12 pb-4 bg-white" style={{ borderBottom: '1px solid #F0F0F0' }}>
        <div className="flex items-center gap-3 mb-4">
          <button
            onClick={onBack}
            className="w-9 h-9 rounded-full flex items-center justify-center"
            style={{ background: '#F3F4F6' }}
          >
            <ChevronLeft size={20} color="#374151" />
          </button>
          <p style={{ fontSize: '16px', fontWeight: 700, color: '#111827' }}>Grant Application</p>
        </div>

        {/* Grant label + step */}
        <div className="flex items-center justify-between">
          <p style={{ fontSize: '13px', color: '#6B7280' }}>Grant: {grant.title.split(' ').slice(0, 3).join(' ')}…</p>
          <p style={{ fontSize: '12px', fontWeight: 600, color: '#1B7A50' }}>Step {step} of 3</p>
        </div>

        {/* Step progress bar */}
        <div className="flex gap-1.5 mt-3">
          {[1, 2, 3].map(s => (
            <div
              key={s}
              className="flex-1 h-1.5 rounded-full transition-all"
              style={{ background: s <= step ? '#1B7A50' : '#E5E7EB' }}
            />
          ))}
        </div>
        <div className="flex mt-1">
          {stepLabels.map((label, i) => (
            <div key={label} className="flex-1">
              <p style={{ fontSize: '10px', color: (i + 1) <= step ? '#1B7A50' : '#9CA3AF', fontWeight: 500 }}>
                {label}
              </p>
            </div>
          ))}
        </div>
      </div>

      {/* Form body */}
      <div className="flex-1 overflow-y-auto px-5 py-5 pb-32">
        {/* Project Name */}
        <div className="mb-5">
          <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
            PROJECT NAME
          </label>
          <input
            value={projectName}
            onChange={e => setProjectName(e.target.value)}
            className="w-full mt-2 px-4 py-3 rounded-xl outline-none transition-all"
            style={{
              border: '1.5px solid #E5E7EB',
              fontSize: '15px',
              color: '#111827',
              background: '#FAFAFA',
            }}
            onFocus={e => (e.target.style.borderColor = '#1B7A50')}
            onBlur={e => (e.target.style.borderColor = '#E5E7EB')}
          />
        </div>

        {/* Requested Funding */}
        <div className="mb-5">
          <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
            REQUESTED FUNDING AMOUNT
          </label>
          <div className="relative mt-2">
            <input
              value={fundingAmt}
              onChange={e => setFundingAmt(e.target.value)}
              className="w-full px-4 py-3 rounded-xl outline-none transition-all"
              style={{
                border: '1.5px solid #E5E7EB',
                fontSize: '15px',
                color: '#111827',
                background: '#FAFAFA',
              }}
              onFocus={e => (e.target.style.borderColor = '#1B7A50')}
              onBlur={e => (e.target.style.borderColor = '#E5E7EB')}
            />
            <span
              className="absolute right-4 top-1/2 -translate-y-1/2"
              style={{ fontSize: '12px', color: '#9CA3AF' }}
            >
              Max Allowed: {grant.amount}
            </span>
          </div>
        </div>

        {/* Description */}
        <div className="mb-5">
          <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
            PROJECT DESCRIPTION &amp; IMPACT
          </label>
          <textarea
            value={description}
            onChange={e => setDescription(e.target.value)}
            rows={6}
            className="w-full mt-2 px-4 py-3 rounded-xl outline-none resize-none transition-all"
            style={{
              border: `1.5px solid ${overLimit ? '#DC2626' : '#E5E7EB'}`,
              fontSize: '14px',
              color: '#374151',
              lineHeight: 1.6,
              background: '#FAFAFA',
            }}
            onFocus={e => (e.target.style.borderColor = overLimit ? '#DC2626' : '#1B7A50')}
            onBlur={e => (e.target.style.borderColor = overLimit ? '#DC2626' : '#E5E7EB')}
          />
          <div className="flex items-center justify-between mt-1.5">
            {overLimit ? (
              <span className="flex items-center gap-1" style={{ fontSize: '11px', color: '#DC2626' }}>
                <AlertCircle size={11} /> Over word limit
              </span>
            ) : (
              <span />
            )}
            <span style={{ fontSize: '11px', color: overLimit ? '#DC2626' : '#9CA3AF' }}>
              {words} / {MAX_WORDS} words
            </span>
          </div>
        </div>

        {/* Supporting Documents */}
        <div className="mb-5">
          <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
            SUPPORTING DOCUMENTS
          </label>
          <div className="mt-2 flex flex-col gap-2">
            {uploadedDocs.map(doc => (
              <div
                key={doc}
                className="flex items-center gap-3 p-3.5 rounded-xl"
                style={{ background: '#EBF6F0', border: '1.5px solid #C8E6D4' }}
              >
                <div
                  className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
                  style={{ background: '#1B7A50' }}
                >
                  <Check size={14} color="#fff" strokeWidth={3} />
                </div>
                <div className="flex-1 min-w-0">
                  <p style={{ fontSize: '13px', fontWeight: 600, color: '#134F34' }}>{doc}</p>
                  <p style={{ fontSize: '11px', color: '#4D9E72' }}>Uploaded Successfully</p>
                </div>
                <button onClick={() => handleRemoveDoc(doc)}>
                  <Trash2 size={16} color="#6B7280" />
                </button>
              </div>
            ))}

            {uploadedDocs.length < 2 && (
              <button
                onClick={handleUpload}
                className="flex flex-col items-center justify-center py-6 rounded-xl transition-all"
                style={{ border: '1.5px dashed #D1D5DB', background: '#FAFAFA' }}
              >
                <Upload size={22} color="#9CA3AF" />
                <p style={{ fontSize: '13px', fontWeight: 600, color: '#374151', marginTop: '8px' }}>
                  Upload Principal Approval Form
                </p>
                <p style={{ fontSize: '11px', color: '#9CA3AF', marginTop: '2px' }}>PDF, PNG or JPG (Max 5MB)</p>
              </button>
            )}
          </div>
        </div>

        {/* Certification */}
        <button
          onClick={() => setCertified(c => !c)}
          className="flex items-start gap-3 text-left w-full"
        >
          <div
            className="w-5 h-5 rounded flex items-center justify-center flex-shrink-0 mt-0.5"
            style={{
              background: certified ? '#1B7A50' : '#fff',
              border: `2px solid ${certified ? '#1B7A50' : '#D1D5DB'}`,
            }}
          >
            {certified && <Check size={11} color="#fff" strokeWidth={3} />}
          </div>
          <p style={{ fontSize: '13px', color: '#6B7280', lineHeight: 1.55 }}>
            I certify that I am a full-time certified public educator and this project adheres to school board standards and curriculum guidelines.
          </p>
        </button>
      </div>

      {/* Action buttons */}
      <div
        className="px-5 py-4 bg-white flex gap-3"
        style={{ borderTop: '1px solid #F0F0F0' }}
      >
        <button
          className="flex-1 py-3.5 rounded-2xl transition-all"
          style={{ border: '1.5px solid #E5E7EB', color: '#374151', fontWeight: 600, fontSize: '15px' }}
        >
          Save Draft
        </button>
        <button
          onClick={handleSubmit}
          disabled={!certified || overLimit || submitted}
          className="flex-1 py-3.5 rounded-2xl flex items-center justify-center gap-2 transition-all"
          style={{
            background: certified && !overLimit ? '#1B7A50' : '#E5E7EB',
            color: certified && !overLimit ? '#fff' : '#9CA3AF',
            fontWeight: 700,
            fontSize: '15px',
            cursor: certified && !overLimit ? 'pointer' : 'not-allowed',
          }}
        >
          {submitted ? 'Submitting…' : 'Submit Application →'}
        </button>
      </div>
    </div>
  );
}
