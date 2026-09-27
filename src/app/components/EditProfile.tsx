import { useState } from 'react';
import { ChevronLeft, Check } from 'lucide-react';
import { SCHOOL_LEVELS, SUBJECT_OPTIONS } from './profileOptions';

export interface ProfileData {
  name: string;
  school: string;
  schoolLevel: string;
  subjects: string[];
  titleI: boolean;
}

interface Props {
  initial: ProfileData;
  onSave: (data: ProfileData) => void;
  onCancel: () => void;
}

export function EditProfile({ initial, onSave, onCancel }: Props) {
  const [name, setName] = useState(initial.name);
  const [school, setSchool] = useState(initial.school);
  const [schoolLevel, setSchoolLevel] = useState(initial.schoolLevel);
  const [subjects, setSubjects] = useState<string[]>(initial.subjects);
  const [titleI, setTitleI] = useState(initial.titleI);

  const canSave = name.trim().length > 0 && school.trim().length > 0 && schoolLevel && subjects.length > 0;

  function toggleSubject(id: string) {
    setSubjects(prev => prev.includes(id) ? prev.filter(s => s !== id) : [...prev, id]);
  }

  function handleSave() {
    if (!canSave) return;
    onSave({ name: name.trim(), school: school.trim(), schoolLevel, subjects, titleI });
  }

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Header */}
      <div className="px-5 pt-12 pb-4 flex items-center gap-3" style={{ borderBottom: '1px solid #F0F0F0' }}>
        <button
          onClick={onCancel}
          className="w-9 h-9 rounded-full flex items-center justify-center"
          style={{ background: '#F3F4F6' }}
        >
          <ChevronLeft size={20} color="#374151" />
        </button>
        <p style={{ fontSize: '16px', fontWeight: 700, color: '#111827' }}>Edit Profile</p>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-5">
        {/* Name */}
        <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
          FULL NAME
        </label>
        <div
          className="flex items-center gap-3 mt-1.5 mb-5 px-4 py-3 rounded-xl"
          style={{ border: '1.5px solid #E5E7EB', background: '#FAFAFA' }}
        >
          <input
            type="text"
            value={name}
            onChange={e => setName(e.target.value)}
            className="flex-1 bg-transparent outline-none"
            style={{ fontSize: '15px', color: '#111827' }}
          />
        </div>

        {/* School name */}
        <label style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280' }}>
          SCHOOL NAME
        </label>
        <div
          className="flex items-center gap-3 mt-1.5 mb-3 px-4 py-3 rounded-xl"
          style={{ border: '1.5px solid #E5E7EB', background: '#FAFAFA' }}
        >
          <input
            type="text"
            value={school}
            onChange={e => setSchool(e.target.value)}
            className="flex-1 bg-transparent outline-none"
            style={{ fontSize: '15px', color: '#111827' }}
          />
        </div>

        <label className="flex items-center gap-2.5 mb-6 cursor-pointer" style={{ userSelect: 'none' }}>
          <button
            type="button"
            onClick={() => setTitleI(t => !t)}
            className="w-5 h-5 rounded-md flex items-center justify-center flex-shrink-0 transition-all"
            style={{
              background: titleI ? '#1B7A50' : '#fff',
              border: titleI ? 'none' : '1.5px solid #D1D5DB',
            }}
          >
            {titleI && <Check size={12} color="#fff" strokeWidth={3} />}
          </button>
          <span style={{ fontSize: '13px', color: '#374151' }}>
            My school is Title I / underfunded
          </span>
        </label>

        {/* School level */}
        <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280', marginBottom: '10px' }}>
          SCHOOL LEVEL
        </p>
        <div className="flex flex-col gap-2.5 mb-6">
          {SCHOOL_LEVELS.map(({ id, label, sub, Icon }) => {
            const active = schoolLevel === id;
            return (
              <button
                key={id}
                onClick={() => setSchoolLevel(id)}
                className="flex items-center gap-3 p-3.5 rounded-xl border-2 text-left transition-all"
                style={{
                  borderColor: active ? '#1B7A50' : '#E5E7EB',
                  background: active ? '#EBF6F0' : '#fff',
                }}
              >
                <div
                  className="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0"
                  style={{ background: active ? '#1B7A50' : '#F3F4F6' }}
                >
                  <Icon size={16} color={active ? '#fff' : '#6B7280'} />
                </div>
                <div className="flex-1 min-w-0">
                  <div style={{ fontWeight: 600, fontSize: '14px', color: active ? '#1B7A50' : '#111827' }}>
                    {label}
                  </div>
                  <div style={{ fontSize: '12px', color: '#6B7280' }}>{sub}</div>
                </div>
                {active && (
                  <div className="w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: '#1B7A50' }}>
                    <Check size={11} color="#fff" strokeWidth={3} />
                  </div>
                )}
              </button>
            );
          })}
        </div>

        {/* Subjects */}
        <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#6B7280', marginBottom: '10px' }}>
          SUBJECTS
        </p>
        <div className="flex flex-wrap gap-2 mb-6">
          {SUBJECT_OPTIONS.map(({ id, label, Icon }) => {
            const active = subjects.includes(id);
            return (
              <button
                key={id}
                onClick={() => toggleSubject(id)}
                className="flex items-center gap-2 px-3.5 py-2 rounded-full border-2 transition-all"
                style={{
                  borderColor: active ? '#1B7A50' : '#E5E7EB',
                  background: active ? '#1B7A50' : '#fff',
                  color: active ? '#fff' : '#374151',
                  fontWeight: 500,
                  fontSize: '13px',
                }}
              >
                <Icon size={13} />
                {label}
                {active && <Check size={11} strokeWidth={3} />}
              </button>
            );
          })}
        </div>
      </div>

      {/* Actions */}
      <div className="px-5 py-4 bg-white" style={{ borderTop: '1px solid #F0F0F0' }}>
        <button
          onClick={handleSave}
          disabled={!canSave}
          className="w-full py-4 rounded-2xl transition-all active:scale-[0.98]"
          style={{
            background: canSave ? '#1B7A50' : '#E5E7EB',
            color: canSave ? '#fff' : '#9CA3AF',
            fontWeight: 700,
            fontSize: '16px',
            cursor: canSave ? 'pointer' : 'not-allowed',
          }}
        >
          Save Changes
        </button>
        <button
          onClick={onCancel}
          className="w-full py-3 mt-1"
          style={{ color: '#6B7280', fontWeight: 600, fontSize: '14px' }}
        >
          Cancel
        </button>
      </div>
    </div>
  );
}
